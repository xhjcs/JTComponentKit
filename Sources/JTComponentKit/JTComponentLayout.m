//
//  JTComponentLayout.m
//  JTComponentKit
//
//  Created by xinghanjie on 2024/11/5.
//

#import "JTComponentLayout.h"

@implementation JTComponentLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];

    NSArray<__kindof UICollectionViewLayoutAttributes *> *attachAttributes = [self additionalPinnedAttributesForHeaders:attributes];

    if (attachAttributes.count > 0) {
        [attributes insertObjects:attachAttributes atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, attachAttributes.count)]];
    }

    CGPoint offset = self.collectionView.contentOffset;
    BOOL isVertical = (self.scrollDirection == UICollectionViewScrollDirectionVertical);

    for (UICollectionViewLayoutAttributes *attr in attributes) {
        if (attr.representedElementKind != UICollectionElementKindSectionHeader) {
            continue;
        }

        NSInteger section = attr.indexPath.section;
        JTComponentHeaderPinningBehavior pinningBehavior = [self.delegate collectionView:self.collectionView pinningBehaviorForHeaderInSection:section];

        if (pinningBehavior == JTComponentHeaderPinningBehaviorNone) {
            continue;
        }

        CGPoint adjustedPosition = attr.frame.origin;

        if (adjustedPosition.x < offset.x) {
            adjustedPosition.x = offset.x;
        }

        if (adjustedPosition.y < offset.y) {
            adjustedPosition.y = offset.y;
        }

        CGRect updatedFrame = attr.frame;
        CGFloat dimension = isVertical ? updatedFrame.size.height : updatedFrame.size.width;
        switch (pinningBehavior) {
            case JTComponentHeaderPinningBehaviorPin: {
                UICollectionViewLayoutAttributes *nextSectionHeaderAttr = [self layoutAttributesForHeaderAtSection:section + 1];

                // 避让下一个header
                [self adjustPosition:&adjustedPosition nextPinnedHeaderAttr:nextSectionHeaderAttr isVertical:isVertical dimension:dimension];

                break;
            }

            case JTComponentHeaderPinningBehaviorPinUntilNextPinHeader: {
                NSInteger nextSection = section + 1;
                NSInteger sectionCount = self.collectionView.numberOfSections;

                // 找到下一个需要吸顶的header
                while (nextSection < sectionCount && [self.delegate collectionView:self.collectionView pinningBehaviorForHeaderInSection:nextSection] == JTComponentHeaderPinningBehaviorNone) {
                    nextSection++;
                }

                UICollectionViewLayoutAttributes *nextSectionHeaderAttr = [self layoutAttributesForHeaderAtSection:nextSection];

                // 避让下一个header
                [self adjustPosition:&adjustedPosition nextPinnedHeaderAttr:nextSectionHeaderAttr isVertical:isVertical dimension:dimension];
                break;
            }

            case JTComponentHeaderPinningBehaviorAlwaysPin:{
                // 由于它是一直吸顶的，所以其它吸顶header需要往下或往右偏移一些
                if (isVertical) {
                    offset.y += dimension;
                } else {
                    offset.x += dimension;
                }

                break;
            }

            default:
                break;
        }
        updatedFrame.origin = adjustedPosition;
        attr.frame = updatedFrame;
        attr.zIndex = INT_MAX - section;
    }

    return attributes;
}

- (void)adjustPosition:(inout CGPoint *)position nextPinnedHeaderAttr:(UICollectionViewLayoutAttributes *)nextAttr isVertical:(BOOL)isVertical dimension:(CGFloat)dimension {
    if (!nextAttr) {
        return;
    }

    if (isVertical) {
        CGFloat maxY = CGRectGetMinY(nextAttr.frame) - dimension;

        if ((*position).y > maxY) {
            (*position).y = maxY;
        }
    } else {
        CGFloat maxX = CGRectGetMinX(nextAttr.frame) - dimension;

        if ((*position).x > maxX) {
            (*position).x = maxX;
        }
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)additionalPinnedAttributesForHeaders:(NSArray<__kindof UICollectionViewLayoutAttributes *> *)attributes {
    UICollectionViewLayoutAttributes *firstAttr = nil;

    for (UICollectionViewLayoutAttributes *attr in attributes) {
        if (attr.representedElementKind == UICollectionElementKindSectionHeader) {
            firstAttr = attr;
            break;
        }
    }

    NSInteger firstSection = firstAttr ? firstAttr.indexPath.section : self.collectionView.numberOfSections - 1;

    if (firstSection <= 0) {
        return nil;
    }

    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *attachAttributes = [NSMutableArray new];
    UICollectionViewLayoutAttributes *lastPinnedHeaderAttr = nil;

    // 找到这个section前面需要一直吸顶的header和最后一个需要保持下个分区前吸顶的header
    for (NSInteger i = 0; i < firstSection; i++) {
        JTComponentHeaderPinningBehavior pinningBehavior = [self.delegate collectionView:self.collectionView pinningBehaviorForHeaderInSection:i];

        if (pinningBehavior == JTComponentHeaderPinningBehaviorAlwaysPin) {
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForHeaderAtSection:i];

            if (attr) {
                [attachAttributes addObject:attr];
                // 遇到一直展示的header，则在它之前的这种header一定不需要展示了
                lastPinnedHeaderAttr = nil;
            }
        } else if (pinningBehavior == JTComponentHeaderPinningBehaviorPinUntilNextPinHeader) {
            lastPinnedHeaderAttr = [self layoutAttributesForHeaderAtSection:i];
        }
    }

    if (lastPinnedHeaderAttr) {
        [attachAttributes addObject:lastPinnedHeaderAttr];
    }

    return attachAttributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForHeaderAtSection:(NSInteger)section {
    return [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
}

@end
