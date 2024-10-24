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

- (CGSize)headerSize {
    return CGSizeMake(100, 100);
}

- (__kindof UIView *)headerView {
    return [self dequeueReusableHeaderViewOfClass:[JTAComponentHeaderView class]];
}

- (NSInteger)numberOfItems {
    return 50;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(50, 50);
}

- (__kindof UIView *)itemViewForIndex:(NSInteger)index {
    return [self dequeueReusableItemViewOfClass:[JTAComponentItemView class] forIndex:index];
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    [self.eventHub emit:@"com.heikki.example" arg0:@(index).stringValue];
}

- (CGSize)footerSize {
    return CGSizeMake(100, 100);
}

- (__kindof UIView *)footerView {
    return [self dequeueReusableFooterViewOfClass:[JTAComponentFooterView class]];
}

@end
