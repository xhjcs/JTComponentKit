//
//  JTComponent.h
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTComponent : NSObject

@property (nonatomic, readonly) CGFloat width;
- (void)setup;
- (void)reloadData;

#pragma mark - Section
- (UIEdgeInsets)inset;
- (CGFloat)minimumLineSpacing;
- (CGFloat)minimumInteritemSpacing;

#pragma mark - Header
- (CGFloat)headerHeight;
- (__kindof UIView *)dequeueReusableHeaderViewWithClass:(Class)viewClass forIndex:(NSInteger)index;
- (void)willDisplayHeaderView;
- (__kindof UIView *)headerViewForIndex:(NSInteger)index;
- (void)didEndDisplayingHeaderView;

#pragma mark - Item
- (NSInteger)numberOfItems;
- (CGSize)sizeForItemAtIndex:(NSInteger)index;
- (__kindof UIView *)dequeueReusableItemViewOfClass:(Class)viewClass forIndex:(NSInteger)index;
- (void)willDisplayItemView;
- (__kindof UIView *)itemViewForIndex:(NSInteger)index;
- (void)didEndDisplayingItemView;

#pragma mark - Footer
- (CGFloat)footerHeight;
- (__kindof UIView *)dequeueReusableFooterViewOfClass:(Class)viewClass forIndex:(NSInteger)index;
- (void)willDisplayFooterView;
- (__kindof UIView *)footerViewForIndex:(NSInteger)index;
- (void)didEndDisplayingFooterView;

@end

NS_ASSUME_NONNULL_END
