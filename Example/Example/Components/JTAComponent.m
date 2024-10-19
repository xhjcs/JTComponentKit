//
//  JTAComponent.m
//  Example
//
//  Created by xinghanjie on 2024/10/15.
//

#import "JTAComponent.h"
#import "JTAComponentFooterView.h"
#import "JTAComponentHeaderView.h"
#import "JTAComponentItemView.h"

@implementation JTAComponent

- (UIEdgeInsets)inset {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGFloat)headerHeight {
    return 100;
}

- (__kindof UIView *)viewForHeaderAtIndex:(NSInteger)index {
    return [self dequeueReusableHeaderViewWithClass:[JTAComponentHeaderView class] forIndex:index];
}

- (NSInteger)itemsCount {
    return 100;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(50, 50);
}

- (__kindof UIView *)viewForItemAtIndex:(NSInteger)index {
    return [self dequeueReusableViewWithClass:[JTAComponentItemView class] forIndex:index];
}

- (CGFloat)footerHeight {
    return 100;
}

- (__kindof UIView *)viewForFooterAtIndex:(NSInteger)index {
    return [self dequeueReusableFooterWithClass:[JTAComponentFooterView class] forIndex:index];
}

@end
