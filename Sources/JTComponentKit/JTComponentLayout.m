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
    NSInteger sectionsCount = self.collectionView.numberOfSections;
    CGPoint offset = self.collectionView.contentOffset;
    BOOL isVertical = (self.scrollDirection == UICollectionViewScrollDirectionVertical);
    // 存储所有需要吸顶的header
    NSMutableArray *pinnedAttributes = [NSMutableArray new];
    // 指向需要吸顶的非一直吸顶header，它同时只存在一个
    UICollectionViewLayoutAttributes *lastPinnedHeaderAttribute = nil;

    for (NSInteger section = 0; section < sectionsCount; section++) {
        JTComponentHeaderPinningBehavior pinningBehavior = [self.delegate collectionView:self.collectionView pinningBehaviorForHeaderInSection:section];

        if (pinningBehavior == JTComponentHeaderPinningBehaviorNone) {
            continue;
        }

        UICollectionViewLayoutAttributes *headerAttr = [self layoutAttributesForHeaderAtSection:section];

        if (!headerAttr) {
            continue;
        }

        // 使zIndex从高到低分布，否则后面的header会盖住前面的header
        headerAttr.zIndex = INT_MAX - section;
        CGRect frame = headerAttr.frame;
        CGFloat dimension = isVertical ? frame.size.height : frame.size.width;

        if (isVertical) {
            if (frame.origin.y > offset.y) {
                // 判断最后一个非一直吸顶header是否会被下一个吸顶header挤走
                if (lastPinnedHeaderAttribute) {
                    CGRect lastPinHeaderFrame = lastPinnedHeaderAttribute.frame;
                    CGFloat maxY = frame.origin.y - lastPinHeaderFrame.size.height;

                    if (lastPinHeaderFrame.origin.y > maxY) {
                        lastPinHeaderFrame.origin.y = maxY;
                    }

                    lastPinnedHeaderAttribute.frame = lastPinHeaderFrame;
                }

                // 后面的header都还没到该吸顶的位置，不用再处理了
                break;
            }
        } else {
            if (frame.origin.x > offset.x) {
                // 判断最后一个非一直吸顶header是否会被下一个吸顶header挤走
                if (lastPinnedHeaderAttribute) {
                    CGRect lastPinHeaderFrame = lastPinnedHeaderAttribute.frame;
                    CGFloat maxX = frame.origin.x - lastPinHeaderFrame.size.width;

                    if (lastPinHeaderFrame.origin.x > maxX) {
                        lastPinHeaderFrame.origin.x = maxX;
                    }

                    lastPinnedHeaderAttribute.frame = lastPinHeaderFrame;
                }

                // 后面的header都还没到该吸顶的位置，不用再处理了
                break;
            }
        }

        CGPoint adjustedPosition = frame.origin;

        if (adjustedPosition.x < offset.x) {
            adjustedPosition.x = offset.x;
        }

        if (adjustedPosition.y < offset.y) {
            adjustedPosition.y = offset.y;
        }

        frame.origin = adjustedPosition;
        headerAttr.frame = frame;

        if (pinningBehavior == JTComponentHeaderPinningBehaviorAlwaysPin) {
            // 由于它是一直吸顶的，肯定需要加上
            [pinnedAttributes addObject:headerAttr];

            // 一直吸顶header，这里增加offset
            if (isVertical) {
                offset.y += dimension;
            } else {
                offset.x += dimension;
            }

            // 当有一个一直吸顶的header时，它之前的非一直吸顶header一定不需要展示了
            lastPinnedHeaderAttribute = nil;
        } else if (pinningBehavior == JTComponentHeaderPinningBehaviorPin) {
            lastPinnedHeaderAttribute = headerAttr;
        }
    }

    if (lastPinnedHeaderAttribute) {
        [pinnedAttributes addObject:lastPinnedHeaderAttribute];
    }

    NSArray<__kindof UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect];

    if (pinnedAttributes.count <= 0) {
        return attributes;
    }

    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *visiableAttributes = pinnedAttributes;
    NSMutableSet<__kindof UICollectionViewLayoutAttributes *> *seenElements = [NSMutableSet setWithArray:pinnedAttributes];

    for (UICollectionViewLayoutAttributes *attr in attributes) {
        if (![seenElements containsObject:attr]) {
            [visiableAttributes addObject:attr];
            [seenElements addObject:attr];
        }
    }

    return visiableAttributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForHeaderAtSection:(NSInteger)section {
    return [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
}

@end
