//
//  JTComponentLayout.m
//  JTComponentKit
//
//  Created by xinghanjie on 2024/11/5.
//

#import "JTComponentLayout.h"

@implementation JTComponentLayout {
    /// 存储所有假header得布局信息，提高查询效率
    NSMutableArray <__kindof UICollectionViewLayoutAttributes *> *_fakeHeadersLayoutAttributes;
    
    /// 记录当前需要显示header的游标，游标之后的header，不需要展示
    NSInteger _visibleHeadersCursor;
    
    /// 存储header得布局信息
    NSMutableArray <__kindof UICollectionViewLayoutAttributes *> *_headersLayoutAttributes;
    
    /// 存储背景视图的布局信息
    NSMutableArray <__kindof UICollectionViewLayoutAttributes *> *_backgroundViewsLayoutAttributes;
}


- (instancetype)init {
    if (self = [super init]) {
        _fakeHeadersLayoutAttributes = [NSMutableArray new];
        
        _headersLayoutAttributes = [NSMutableArray new];
        _backgroundViewsLayoutAttributes = [NSMutableArray new];
    }

    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    if (context.invalidateDataSourceCounts || context.invalidateEverything) {
        [_fakeHeadersLayoutAttributes removeAllObjects];
        _visibleHeadersCursor = 0;
        [_headersLayoutAttributes removeAllObjects];
        [_backgroundViewsLayoutAttributes removeAllObjects];
    }
    [super invalidateLayoutWithContext:context];
}

- (void)prepareLayout {
    [super prepareLayout];
    const NSInteger sectionsCount = self.collectionView.numberOfSections;
    for (NSInteger section = _fakeHeadersLayoutAttributes.count; section < sectionsCount; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *fakeHeaderAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (!fakeHeaderAttributes) {
            fakeHeaderAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[indexPath copy]];
        }
        [_fakeHeadersLayoutAttributes addObject:fakeHeaderAttributes];
        
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:JTComponentElementKindSectionHeader withIndexPath:[indexPath copy]];
        // 使zIndex从高到低分布，否则后面的header会盖住前面的header
        headerAttributes.zIndex = NSIntegerMax - section;
        [_headersLayoutAttributes addObject:headerAttributes];
    }
    [self prepareHeadersLayout];
    [self prepareBackgoundViewsLayout];
}

- (void)prepareHeadersLayout {
    const NSInteger sectionsCount = _fakeHeadersLayoutAttributes.count;
    NSCAssert(_headersLayoutAttributes.count == sectionsCount, @"两者必须相等");
    if (_headersLayoutAttributes.count != sectionsCount) return;
    
    const CGSize collectionViewSize = self.collectionView.bounds.size;
    CGPoint offset = self.collectionView.contentOffset;
    // 当前可见区域右下角的点
    const CGPoint maxPoint = CGPointMake(offset.x + collectionViewSize.width, offset.y + collectionViewSize.height);
    const BOOL isVertical = (self.scrollDirection == UICollectionViewScrollDirectionVertical);
    // 指向需要吸顶的非一直吸顶header，它同时只存在一个
    UICollectionViewLayoutAttributes *lastPinnedHeaderAttribute = nil;
    
    NSInteger section = 0;
    for (; section < sectionsCount; section++) {
        UICollectionViewLayoutAttributes *fakeHeaderAttr = _fakeHeadersLayoutAttributes[section];
        CGRect frame = fakeHeaderAttr.frame;

        // 超出可见区域，不处理
        if (isVertical) {
            if (frame.origin.y > maxPoint.y) break;
        } else {
            if (frame.origin.x > maxPoint.x) break;
        }

        UICollectionViewLayoutAttributes *headerAttr = _headersLayoutAttributes[section];
        headerAttr.frame = frame;
        JTComponentHeaderPinningBehavior pinningBehavior = [self.delegate collectionView:self.collectionView pinningBehaviorForHeaderInSection:section];

        if (pinningBehavior == JTComponentHeaderPinningBehaviorNone) {
            continue;
        }
        
        if (isVertical) {
            if (frame.origin.y > offset.y) {
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

        UICollectionViewLayoutAttributes *newLastPinnedHeaderAttribute = nil;

        if (pinningBehavior == JTComponentHeaderPinningBehaviorAlwaysPin) {
            // 一直吸顶header，这里增加offset
            if (isVertical) {
                offset.y += dimension;
            } else {
                offset.x += dimension;
            }
        } else if (pinningBehavior == JTComponentHeaderPinningBehaviorPin) {
            newLastPinnedHeaderAttribute = headerAttr;
        }

        // 当有一个一直吸顶的header时，它之前的非一直吸顶header一定不需要展示了,把它的frame设置到屏幕外，然后指控指针不再处理
        if (lastPinnedHeaderAttribute) {
            CGRect lastPinnedHeaderFrame = lastPinnedHeaderAttribute.frame;

            if (isVertical) {
                lastPinnedHeaderFrame.origin.y = maxPoint.y + 10.0;
            } else {
                lastPinnedHeaderFrame.origin.x = maxPoint.x + 10.0;
            }

            lastPinnedHeaderAttribute.frame = lastPinnedHeaderFrame;
            lastPinnedHeaderAttribute = nil;
        }

        lastPinnedHeaderAttribute = newLastPinnedHeaderAttribute;
    }
    
    _visibleHeadersCursor = section;
}

- (void)prepareBackgoundViewsLayout {
    const NSInteger sectionsCount = _fakeHeadersLayoutAttributes.count;
    if (_backgroundViewsLayoutAttributes.count >= sectionsCount) return;
    
    NSCAssert(_backgroundViewsLayoutAttributes.count == 0, @"代码走到这里_backgroundViewsLayoutAttributes必然被清空");
    if (_backgroundViewsLayoutAttributes.count != 0) return;
    
    const CGSize collectionViewSize = self.collectionView.bounds.size;
    const BOOL isVertical = (self.scrollDirection == UICollectionViewScrollDirectionVertical);
    UIEdgeInsets lastInsets = UIEdgeInsetsZero;
    UICollectionViewLayoutAttributes *lastAttr = nil;
    
    for (NSInteger section = 0; section <= sectionsCount; section++) {
        UICollectionViewLayoutAttributes *attr = nil;
        CGPoint origin = CGPointZero;

        if (section >= sectionsCount) {
            origin = isVertical ? CGPointMake(0, self.collectionViewContentSize.height) : CGPointMake(self.collectionViewContentSize.width, 0);
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
            [_backgroundViewsLayoutAttributes addObject:lastAttr];
        }

        if (attr) {
            lastAttr = attr;
            lastInsets = [self.delegate collectionView:self.collectionView insetsForBackgroundViewInSection:section];
        }
    }
    
    NSCAssert(_backgroundViewsLayoutAttributes.count == sectionsCount, @"两者必须相等");
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    NSInteger idx = 0;
    for (UICollectionViewLayoutAttributes *attr in _headersLayoutAttributes) {
        if (idx < _visibleHeadersCursor && CGRectIntersectsRect(attr.frame, rect)) [attributes addObject:attr];
        idx++;
    }
    
    for (UICollectionViewLayoutAttributes *attr in _backgroundViewsLayoutAttributes) {
        if (CGRectIntersectsRect(attr.frame, rect)) [attributes addObject:attr];
    }

    return [attributes copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSInteger idx = indexPath.section;
    if (elementKind == JTComponentElementKindSectionHeader) {
        if (idx < _visibleHeadersCursor && idx < _headersLayoutAttributes.count) return _headersLayoutAttributes[idx];
    } else if (elementKind == JTComponentElementKindSectionBackground) {
        if (idx < _backgroundViewsLayoutAttributes.count) return _backgroundViewsLayoutAttributes[idx];
    }
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}

// 得到该分区的滑动偏移量，用来滑动到该分区
- (CGPoint)offsetForSection:(NSInteger)section {
    CGPoint offset = [self originForSection:section];
    CGSize pinnedHeadersSize = [self pinnedHeadersSizeForSection:section];

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        offset.y -= pinnedHeadersSize.height;
        CGFloat maxY = self.collectionViewContentSize.height - self.collectionView.bounds.size.height;
        if (maxY <= 0.0) return self.collectionView.contentOffset;
        if (offset.y > maxY) offset.y = maxY;
    } else {
        offset.x -= pinnedHeadersSize.width;
        CGFloat maxX = self.collectionViewContentSize.width - self.collectionView.bounds.size.width;
        if (maxX <= 0.0) return self.collectionView.contentOffset;
        if (offset.x > maxX) offset.x = maxX;
    }

    return offset;
}

// 滑动到该分区时，所有的一直吸顶的header的大小，用来辅助计算滑动到该分区的偏移量，因为滑动到该分区时，该分区需要定位到所有一直吸顶的header下面
- (CGSize)pinnedHeadersSizeForSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    const BOOL isVertical = (self.scrollDirection == UICollectionViewScrollDirectionVertical);
    const NSInteger sectionsCount = _fakeHeadersLayoutAttributes.count;

    for (NSInteger i = 0; i < sectionsCount && i < section; i++) {
        JTComponentHeaderPinningBehavior pinningBehavior = [self.delegate collectionView:self.collectionView pinningBehaviorForHeaderInSection:i];
        if (pinningBehavior != JTComponentHeaderPinningBehaviorAlwaysPin) continue;
        
        UICollectionViewLayoutAttributes *headerAttr = _fakeHeadersLayoutAttributes[i];
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

// 获取该分区原点的位置
- (CGPoint)originForSection:(NSInteger)section {
    if (section >= _fakeHeadersLayoutAttributes.count) return CGPointZero;
    
    UICollectionViewLayoutAttributes *firstAttr = _fakeHeadersLayoutAttributes[section];
    CGPoint origin = firstAttr.frame.origin;

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        origin.x = 0;
    } else {
        origin.y = 0;
    }

    return origin;
}

@end
