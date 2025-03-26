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
- (void)componentDidMount;
- (void)componentWillUnmount;

#pragma mark - Section
- (NSInteger)numberOfSections;
- (UIEdgeInsets)insetForSection:(NSInteger)section;
- (CGFloat)minimumLineSpacingInSection:(NSInteger)section;
- (CGFloat)minimumInteritemSpacingInSection:(NSInteger)section;

#pragma mark - Header
- (CGSize)sizeForHeaderInSection:(NSInteger)section;
- (__kindof UIView *)dequeueReusableHeaderViewWithClass:(Class)viewClass forSection:(NSInteger)section;
- (void)willDisplayHeaderView:(__kindof UIView *)view forSection:(NSInteger)section;
- (__kindof UIView *)headerViewForSection:(NSInteger)section;
- (void)didEndDisplayingHeaderView:(__kindof UIView *)view forSection:(NSInteger)section;

#pragma mark - Item
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (__kindof UIView *)dequeueReusableItemViewWithClass:(Class)viewClass forIndexPath:(NSIndexPath *)indexPath;
- (void)willDisplayItemView:(__kindof UIView *)view atIndexPath:(NSIndexPath *)indexPath;
- (__kindof UIView *)viewForItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)didEndDisplayingItemView:(__kindof UIView *)view atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Footer
- (CGSize)sizeForFooterInSection:(NSInteger)section;
- (__kindof UIView *)dequeueReusableFooterViewWithClass:(Class)viewClass forSection:(NSInteger)section;
- (void)willDisplayFooterView:(__kindof UIView *)view forSection:(NSInteger)section;
- (__kindof UIView *)footerViewForSection:(NSInteger)section;
- (void)didEndDisplayingFooterView:(__kindof UIView *)view forSection:(NSInteger)section;

#pragma mark - Background
- (UIEdgeInsets)insetForBackgroundViewInSection:(NSInteger)section;
- (NSInteger)zIndexForBackgroundViewInSection:(NSInteger)section;
- (__kindof UIView *)dequeueReusableBackgroundViewWithClass:(Class)viewClass forSection:(NSInteger)section;
- (__kindof UIView *)backgroundViewForSection:(NSInteger)section;

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
