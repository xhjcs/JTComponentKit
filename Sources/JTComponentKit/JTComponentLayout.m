//
//  JTComponentLayout.m
//  JTComponentKit
//
//  Created by xinghanjie on 2024/11/5.
//

#import "JTComponentLayout.h"

@interface JTComponentLayout ()

@property (nonatomic) NSMutableArray <__kindof UICollectionViewLayoutAttributes *> *visibleHeadersAttributes;
@property (nonatomic) NSMutableArray <__kindof UICollectionViewLayoutAttributes *> *visibleBackgroundViewsAttributes;

@end

@implementation JTComponentLayout

- (instancetype)init {
    if (self = [super init]) {
        _visibleHeadersAttributes = [NSMutableArray new];
        _visibleBackgroundViewsAttributes = [NSMutableArray new];
    }

    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self prepareHeadersLayout];
    [self prepareBackgoundViewsLayout];
}

- (void)prepareHeadersLayout {
    [self.visibleHeadersAttributes removeAllObjects];
    const NSInteger sectionsCount = self.collectionView.numberOfSections;
    const CGSize collectionViewSize = self.collectionView.bounds.size;
    CGPoint offset = self.collectionView.contentOffset;
    // 当前可见区域右下角的点
    const CGPoint maxPoint = CGPointMake(offset.x + collectionViewSize.width, offset.y + collectionViewSize.height);
    const BOOL isVertical = (self.scrollDirection == UICollectionViewScrollDirectionVertical);
    // 指向需要吸顶的非一直吸顶header，它同时只存在一个
    UICollectionViewLayoutAttributes *lastPinnedHeaderAttribute = nil;

    for (NSInteger section = 0; section < sectionsCount; section++) {
        UICollectionViewLayoutAttributes *fakeHeaderAttr = [self layoutAttributesForHeaderAtSection:section];
        if (!fakeHeaderAttr) continue;
        
        CGRect frame = fakeHeaderAttr.frame;

        // 超出可见区域，不处理
        if (isVertical) {
            if (frame.origin.y > maxPoint.y) break;
        } else {
            if (frame.origin.x > maxPoint.x) break;
        }

        UICollectionViewLayoutAttributes *headerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:JTComponentElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        // 使zIndex从高到低分布，否则后面的header会盖住前面的header
        headerAttr.zIndex = NSIntegerMax - section;
        headerAttr.frame = frame;
        JTComponentHeaderPinningBehavior pinningBehavior = [self.delegate collectionView:self.collectionView pinningBehaviorForHeaderInSection:section];

        if (pinningBehavior == JTComponentHeaderPinningBehaviorNone) {
            [self.visibleHeadersAttributes addObject:headerAttr];
            continue;
        }
        
        if (isVertical) {
            if (frame.origin.y > offset.y) {
                [self.visibleHeadersAttributes addObject:headerAttr];
                if (lastPinnedHeaderAttribute) {
                    CGRect lastPinnedHeaderFrame = lastPinnedHeaderAttribute.frame;
                    const CGFloat lastPinnedHeaderMaxY = frame.origin.y - lastPinnedHeaderFrame.size.height;
                    if (lastPinnedHeaderFrame.origin.y > lastPinnedHeaderMaxY) lastPinnedHeaderFrame.origin.y = lastPinnedHeaderMaxY;
                    lastPinnedHeaderAttribute.frame = lastPinnedHeaderFrame;
                }
                continue;
            }
        } else {
            if (frame.origin.x > offset.x) {
                [self.visibleHeadersAttributes addObject:headerAttr];
                if (lastPinnedHeaderAttribute) {
                    CGRect lastPinnedHeaderFrame = lastPinnedHeaderAttribute.frame;
                    const CGFloat lastPinnedHeaderMaxX = frame.origin.x - lastPinnedHeaderFrame.size.width;
                    if (lastPinnedHeaderFrame.origin.x > lastPinnedHeaderMaxX) lastPinnedHeaderFrame.origin.x = lastPinnedHeaderMaxX;
                    lastPinnedHeaderAttribute.frame = lastPinnedHeaderFrame;
                }
                continue;
            }
        }
        
        CGFloat dimension = isVertical ? frame.size.height : frame.size.width;
        CGPoint adjustedPosition = frame.origin;
        if (adjustedPosition.x < offset.x) adjustedPosition.x = offset.x;
        if (adjustedPosition.y < offset.y) adjustedPosition.y = offset.y;
        frame.origin = adjustedPosition;
        headerAttr.frame = frame;

        if (pinningBehavior == JTComponentHeaderPinningBehaviorAlwaysPin) {
            // 由于它是一直吸顶的，肯定需要加上
            [self.visibleHeadersAttributes addObject:headerAttr];

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

    if (lastPinnedHeaderAttribute) [self.visibleHeadersAttributes addObject:lastPinnedHeaderAttribute];
}

- (void)prepareBackgoundViewsLayout {
    [self.visibleBackgroundViewsAttributes removeAllObjects];
    const NSInteger sectionsCount = self.collectionView.numberOfSections;
    const CGSize collectionViewSize = self.collectionView.bounds.size;
    // 当前可见区域左上角的点
    const CGPoint offset = self.collectionView.contentOffset;
    // 当前可见区域右下角的点
    const CGPoint maxPoint = CGPointMake(offset.x + collectionViewSize.width, offset.y + collectionViewSize.height);
    const BOOL isVertical = (self.scrollDirection == UICollectionViewScrollDirectionVertical);
    UIEdgeInsets lastInsets = UIEdgeInsetsZero;
    UICollectionViewLayoutAttributes *lastAttr = nil;
    
    for (NSInteger section = 0; section <= sectionsCount; section++) {
        UICollectionViewLayoutAttributes *attr = nil;
        CGPoint origin = CGPointZero;

        if (section >= sectionsCount) {
            origin = isVertical ? CGPointMake(0, self.collectionView.contentSize.height) : CGPointMake(self.collectionView.contentSize.width, 0);
        } else {
            origin = [self originForSection:section];
            attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:JTComponentElementKindSectionBackground withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attr.zIndex = [self.delegate collectionView:self.collectionView zIndexForBackgroundViewInSection:section];
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

            lastAttr.frame = UIEdgeInsetsInsetRect(lastFrame, lastInsets);
            [self.visibleBackgroundViewsAttributes addObject:lastAttr];
        }

        // 超出可见区域，不处理
        if (isVertical) {
            if (origin.y > maxPoint.y) break;
        } else {
            if (origin.x > maxPoint.x) break;
        }

        if (attr) {
            lastAttr = attr;
            lastInsets = [self.delegate collectionView:self.collectionView insetsForBackgroundViewInSection:section];
        }
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    NSArray *additionalAttributesArray = @[self.visibleHeadersAttributes, self.visibleBackgroundViewsAttributes];
    for (NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *additionalAttributes in additionalAttributesArray) {
        for (UICollectionViewLayoutAttributes *attr in additionalAttributes) {
            if (CGRectIntersectsRect(attr.frame, rect)) [attributes addObject:attr];
        }
    }

    return [attributes copy];
}

// 得到该分区的滑动偏移量，用来滑动到该分区
- (CGPoint)offsetForSection:(NSInteger)section {
    CGPoint offset = [self originForSection:section];
    CGSize pinnedHeadersSize = [self pinnedHeadersSizeForSection:section];

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        offset.y -= pinnedHeadersSize.height;
        CGFloat maxY = self.collectionView.contentSize.height - self.collectionView.bounds.size.height;
        if (maxY <= 0.0) return self.collectionView.contentOffset;
        if (offset.y > maxY) offset.y = maxY;
    } else {
        offset.x -= pinnedHeadersSize.width;
        CGFloat maxX = self.collectionView.contentSize.width - self.collectionView.bounds.size.width;
        if (maxX <= 0.0) return self.collectionView.contentOffset;
        if (offset.x > maxX) offset.x = maxX;
    }

    return offset;
}

// 滑动到该分区时，所有的一直吸顶的header的大小，用来辅助计算滑动到该分区的偏移量，因为滑动到该分区时，该分区需要定位到所有一直吸顶的header下面
- (CGSize)pinnedHeadersSizeForSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    BOOL isVertical = (self.scrollDirection == UICollectionViewScrollDirectionVertical);

    for (NSInteger i = 0; i < section; i++) {
        JTComponentHeaderPinningBehavior pinningBehavior = [self.delegate collectionView:self.collectionView pinningBehaviorForHeaderInSection:i];
        if (pinningBehavior != JTComponentHeaderPinningBehaviorAlwaysPin) continue;
        UICollectionViewLayoutAttributes *headerAttr = [self layoutAttributesForHeaderAtSection:i];
        if (!headerAttr) continue;
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

// 获取该分区原点的位置
- (CGPoint)originForSection:(NSInteger)section {
    // 第一个分区，原点一定是0
    if (section <= 0) return CGPointZero;
    
    UICollectionViewLayoutAttributes *firstAttr = [self layoutAttributesForHeaderAtSection:section];
    NSCParameterAssert(firstAttr);
    if (!firstAttr) return CGPointZero;

    CGPoint origin = firstAttr.frame.origin;

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        origin.x = 0;
    } else {
        origin.y = 0;
    }

    return origin;
}

@end
