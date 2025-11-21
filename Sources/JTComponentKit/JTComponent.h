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
- (void)reloadData:(BOOL)animated;
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

@interface JTComponent (Movable)

/// 判断指定位置的 item 是否允许被移动
/// @param index item 在当前 component 中的位置
/// @return YES 表示该位置的 item 可以被移动，NO 表示不允许。默认NO
- (BOOL)canMoveItemAtIndex:(NSInteger)index;

/// 判断能不能移动到目标位置
/// @param destinationIndex item 在当前 component 中的目标位置
/// @param sourceComponent 原始 component
/// @param sourceIndex     item 在原始 component 中的位置
/// @return YES 表示可以接收该 item 到目标位置，NO 表示不允许。默认仅允许自身模块内的 item
- (BOOL)canMoveItemToIndex:(NSInteger)destinationIndex
             fromComponent:(JTComponent *)sourceComponent
                   atIndex:(NSInteger)sourceIndex;

/// 当当前 component 内的某个 item 被移动走时触发
/// @param index 被移动的 item 在当前 component 中的位置
/// @return 被移走的对象（供目标 component 接收时使用）
- (id)didMoveItemFromIndex:(NSInteger)index;

/// 当有一个 item 被移动到当前 component 后触发
/// @param item 被移动的对象
/// @param index 插入到当前 component 的位置
- (void)didMoveItem:(id)item toIndex:(NSInteger)index;

@end

@interface JTComponent (PageLifeCycle) <JTComponentPageLifeCycleProtocol>

@end

@interface JTComponent (Scroll) <UIScrollViewDelegate>

@end

@interface JTComponent (Pin)

- (JTComponentHeaderPinningBehavior)pinningBehaviorForHeader;

@end

NS_ASSUME_NONNULL_END
