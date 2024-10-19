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
- (void)willDisplayHeader;
- (__kindof UIView *)viewForHeaderAtIndex:(NSInteger)index;
- (void)didEndDisplayingHeader;

#pragma mark - Item
- (NSInteger)itemsCount;
- (CGSize)sizeForItemAtIndex:(NSInteger)index;
- (__kindof UIView *)dequeueReusableViewWithClass:(Class)viewClass forIndex:(NSInteger)index;
- (void)willDisplayView;
- (__kindof UIView *)viewForItemAtIndex:(NSInteger)index;
- (void)didEndDisplayingView;

#pragma mark - Footer
- (CGFloat)footerHeight;
- (__kindof UIView *)dequeueReusableFooterWithClass:(Class)viewClass forIndex:(NSInteger)index;
- (void)willDisplayFooter;
- (__kindof UIView *)viewForFooterAtIndex:(NSInteger)index;
- (void)didEndDisplayingFooter;

@end

NS_ASSUME_NONNULL_END
