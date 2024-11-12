//
//  JTComponent.h
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/16.
//

#import <UIKit/UIKit.h>
#import "JTComponentCommunicationProtocol.h"
#import "JTComponentDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTComponent : NSObject

#pragma mark - Public
@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) UICollectionView *collectionView;
- (void)reloadData;
- (void)scrollToSelf:(BOOL)animated;

#pragma mark - Life Cycle
- (void)componentDidMount;
- (void)componentWillUnmount;

#pragma mark - Section
- (UIEdgeInsets)inset;
- (CGFloat)minimumLineSpacing;
- (CGFloat)minimumInteritemSpacing;

#pragma mark - Header
- (CGSize)headerSize;
- (__kindof UIView *)dequeueReusableHeaderViewOfClass:(Class)viewClass;
- (void)willDisplayHeaderView;
- (__kindof UIView *)headerView;
- (void)didEndDisplayingHeaderView;

#pragma mark - Item
- (NSInteger)numberOfItems;
- (CGSize)sizeForItemAtIndex:(NSInteger)index;
- (__kindof UIView *)dequeueReusableItemViewOfClass:(Class)viewClass forIndex:(NSInteger)index;
- (void)willDisplayItemView;
- (__kindof UIView *)itemViewForIndex:(NSInteger)index;
- (void)didSelectItemAtIndex:(NSInteger)index;
- (void)didEndDisplayingItemView;

#pragma mark - Footer
- (CGSize)footerSize;
- (__kindof UIView *)dequeueReusableFooterViewOfClass:(Class)viewClass;
- (void)willDisplayFooterView;
- (__kindof UIView *)footerView;
- (void)didEndDisplayingFooterView;

#pragma mark - Background
- (UIEdgeInsets)insetForBackgroundView;
- (NSInteger)zIndexForBackgroundView;
- (__kindof UIView *)dequeueReusableBackgroundViewOfClass:(Class)viewClass;
- (__kindof UIView *)backgroundView;

@end

@interface JTComponent (Communication) <JTComponentCommunicationProtocol>

@end

@interface JTComponent (Scroll) <UIScrollViewDelegate>

@end

@interface JTComponent (Pin)

- (JTComponentHeaderPinningBehavior)pinningBehaviorForHeader;

@end

NS_ASSUME_NONNULL_END
