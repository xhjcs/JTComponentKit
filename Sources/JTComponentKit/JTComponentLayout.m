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

    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *visiableAttributes = pinnedAttributes;
    NSMutableSet<__kindof UICollectionViewLayoutAttributes *> *seenAttributes = [NSMutableSet setWithArray:pinnedAttributes];

    NSInteger minSection = INT_MAX;
    NSInteger maxSection = 0;

    for (UICollectionViewLayoutAttributes *attr in attributes) {
        NSInteger section = attr.indexPath.section;

        if (minSection > section) {
            minSection = section;
        }

        if (maxSection < section) {
            maxSection = section;
        }

        if (![seenAttributes containsObject:attr]) {
            [visiableAttributes addObject:attr];
            [seenAttributes addObject:attr];
        }
    }

    // 背景视图
    NSArray<__kindof UICollectionViewLayoutAttributes *> *backgroundAttributes = [self layoutAttributesForBackgroundViewsInSectionRange:NSMakeRange(minSection, maxSection - minSection + 1)];
    [visiableAttributes addObjectsFromArray:backgroundAttributes];

    return visiableAttributes;
}

// 得到该分区的滑动偏移量，用来滑动到该分区
- (CGPoint)offsetForSection:(NSInteger)section {
    CGPoint offset = [self originForSection:section];
    CGSize pinnedHeadersSize = [self pinnedHeadersSizeForSection:section];

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        offset.y -= pinnedHeadersSize.height;
        CGFloat maxY = self.collectionView.contentSize.height - self.collectionView.bounds.size.height;

        if (maxY <= 0.0) {
            return self.collectionView.contentOffset;
        }

        if (offset.y > maxY) {
            offset.y = maxY;
        }
    } else {
        offset.x -= pinnedHeadersSize.width;
        CGFloat maxX = self.collectionView.contentSize.width - self.collectionView.bounds.size.width;

        if (maxX <= 0.0) {
            return self.collectionView.contentOffset;
        }

        if (offset.x > maxX) {
            offset.x = maxX;
        }
    }

    return offset;
}

// 滑动到该分区时，所有的一直吸顶的header的大小，用来辅助计算滑动到该分区的偏移量，因为滑动到该分区时，该分区需要定位到所有一直吸顶的header下面
- (CGSize)pinnedHeadersSizeForSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    BOOL isVertical = (self.scrollDirection == UICollectionViewScrollDirectionVertical);

    for (NSInteger i = 0; i < section; i++) {
        JTComponentHeaderPinningBehavior pinningBehavior = [self.delegate collectionView:self.collectionView pinningBehaviorForHeaderInSection:i];

        if (pinningBehavior != JTComponentHeaderPinningBehaviorAlwaysPin) {
            continue;
        }

        UICollectionViewLayoutAttributes *headerAttr = [self layoutAttributesForHeaderAtSection:i];

        if (!headerAttr) {
            continue;
        }

        CGRect frame = headerAttr.frame;

        if (isVertical) {
            size.width = frame.size.width;
            size.height += frame.size.height;
        } else {
            size.width += frame.size.width;
            size.height = frame.size.height;
        }
    }

    return size;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForHeaderAtSection:(NSInteger)section {
    return [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
}

// 创建分区背景视图的layoutAttributes
- (nullable NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForBackgroundViewsInSectionRange:(NSRange)sectionRange {
    NSInteger sectionsCount = self.collectionView.numberOfSections;
    BOOL isVertical = (self.scrollDirection == UICollectionViewScrollDirectionVertical);
    CGSize collectionViewSize = self.collectionView.bounds.size;
    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *backgroundAttributes = [NSMutableArray new];
    UICollectionViewLayoutAttributes *lastAttr = nil;
    UIEdgeInsets lastInset = UIEdgeInsetsZero;

    for (NSInteger section = sectionRange.location; section <= NSMaxRange(sectionRange) && section <= sectionsCount; section++) {
        UICollectionViewLayoutAttributes *attr = nil;
        CGPoint origin = CGPointZero;

        if (section >= sectionsCount) {
            origin = isVertical ? CGPointMake(0, self.collectionView.contentSize.height) : CGPointMake(self.collectionView.contentSize.width, 0);
        } else {
            attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:JTComponentElementKindSectionBackground withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attr.zIndex = [self.delegate collectionView:self.collectionView zIndexForBackgroundViewInSection:section];
            origin = [self originForSection:section];
            attr.frame = CGRectMake(origin.x, origin.y, 0, 0);
        }

        // 用下个section的原点计算上一个section背景的大小
        if (lastAttr) {
            CGRect lastFrame = lastAttr.frame;

            if (isVertical) {
                lastFrame.size = CGSizeMake(collectionViewSize.width, origin.y - lastFrame.origin.y);
            } else {
                lastFrame.size = CGSizeMake(origin.x - lastFrame.origin.x, collectionViewSize.height);
            }

            lastAttr.frame = UIEdgeInsetsInsetRect(lastFrame, lastInset);
            [backgroundAttributes addObject:lastAttr];
        }

        if (attr) {
            lastAttr = attr;
            lastInset = [self.delegate collectionView:self.collectionView insetForBackgroundViewInSection:section];
        }
    }

    return backgroundAttributes;
}

// 获取该分区原点的位置
- (CGPoint)originForSection:(NSInteger)section {
    // 第一个分区，原点一定是0
    if (section <= 0) {
        return CGPointZero;
    }

    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    UICollectionViewLayoutAttributes *firstAttr = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:firstIndexPath];
    // 因section内边距，需要偏移的量
    CGPoint dimension = CGPointZero;
    BOOL isVertical = (self.scrollDirection == UICollectionViewScrollDirectionVertical);

    if (!firstAttr && [self.collectionView numberOfItemsInSection:section] > 0) {
        UIEdgeInsets inset = [self insetForSection:section];
        firstAttr = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:firstIndexPath];
        dimension.x = inset.left;
        dimension.y = inset.top;
    }

    if (!firstAttr) {
        UIEdgeInsets inset = [self insetForSection:section];
        firstAttr = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:firstIndexPath];
        dimension.x = inset.left + inset.right;
        dimension.y = inset.top + inset.bottom;
    }

    if (!firstAttr) {
        NSCParameterAssert(firstAttr);
        return CGPointZero;
    }

    CGPoint origin = firstAttr.frame.origin;

    if (isVertical) {
        origin.x = 0;
        origin.y -= dimension.y;
    } else {
        origin.x -= dimension.x;
        origin.y = 0;
    }

    return origin;
}

- (UIEdgeInsets)insetForSection:(NSInteger)section {
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;

    if (![delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return UIEdgeInsetsZero;
    }

    return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
}

@end
