//
//  JTComponent.h
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/16.
//

#import <UIKit/UIKit.h>
#import "JTEventHub.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTComponent : NSObject

@property (nonatomic, readonly) JTEventHub *eventHub;

@property (nonatomic, readonly) CGSize size;
- (void)setup;
- (void)reloadData;

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
- (void)didEndDisplayingItemView;

#pragma mark - Footer
- (CGSize)footerSize;
- (__kindof UIView *)dequeueReusableFooterViewOfClass:(Class)viewClass;
- (void)willDisplayFooterView;
- (__kindof UIView *)footerView;
- (void)didEndDisplayingFooterView;

@end

NS_ASSUME_NONNULL_END
