//
//  JTComponent.h
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/16.
//

#import <UIKit/UIKit.h>
#import "JTComponentCommunicationProtocol.h"
#import "JTComponentDefines.h"
#import "JTComponentPageLifeCycleProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTComponent : NSObject

#pragma mark - Public
@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) UICollectionView *collectionView;
- (void)reloadData;
- (void)scrollToSelf:(BOOL)animated;

#pragma mark - Life Cycle
- (void)setup;
- (void)componentDidMount;
- (void)componentWillUnmount;

#pragma mark - Section
- (UIEdgeInsets)insets;
- (CGFloat)minimumLineSpacing;
- (CGFloat)minimumInteritemSpacing;

#pragma mark - Header
- (CGSize)headerSize;
- (__kindof UIView *)dequeueReusableHeaderViewOfClass:(Class)viewClass;
- (void)willDisplayHeaderView:(__kindof UIView *)headerView;
- (__kindof UIView *)headerView;
- (void)didEndDisplayingHeaderView:(__kindof UIView *)headerView;

#pragma mark - Item
- (NSInteger)numberOfItems;
- (CGSize)sizeForItemAtIndex:(NSInteger)index;
- (__kindof UIView *)dequeueReusableItemViewOfClass:(Class)viewClass forIndex:(NSInteger)index;
- (void)willDisplayItemView:(__kindof UIView *)itemView atIndex:(NSInteger)index;
- (__kindof UIView *)itemViewForIndex:(NSInteger)index;
- (void)didSelectItemAtIndex:(NSInteger)index;
- (void)didEndDisplayingItemView:(__kindof UIView *)itemView atIndex:(NSInteger)index;

#pragma mark - Footer
- (CGSize)footerSize;
- (__kindof UIView *)dequeueReusableFooterViewOfClass:(Class)viewClass;
- (void)willDisplayFooterView:(__kindof UIView *)footerView;
- (__kindof UIView *)footerView;
- (void)didEndDisplayingFooterView:(__kindof UIView *)footerView;

#pragma mark - Background
- (UIEdgeInsets)insetsForBackgroundView;
- (NSInteger)zIndexForBackgroundView;
- (__kindof UIView *)dequeueReusableBackgroundViewOfClass:(Class)viewClass;
- (__kindof UIView *)backgroundView;

@end

@interface JTComponent (Communication) <JTComponentCommunicationProtocol>

@end

@interface JTComponent (PageLifeCycle) <JTComponentPageLifeCycleProtocol>

@end

@interface JTComponent (Scroll) <UIScrollViewDelegate>

@end

@interface JTComponent (Pin)

- (JTComponentHeaderPinningBehavior)pinningBehaviorForHeader;

@end

NS_ASSUME_NONNULL_END
