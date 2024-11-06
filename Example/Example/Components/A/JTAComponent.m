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

- (JTComponentHeaderPinningBehavior)pinningBehaviorForHeader {
    return self.pinningBehavior;
}

- (UIEdgeInsets)inset {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGSize)headerSize {
    return CGSizeMake(100, 100);
}

- (__kindof UIView *)headerView {
    UILabel *header = [self dequeueReusableHeaderViewOfClass:[UILabel class]];
//    __weak __typeof(self) weakSelf = self;
//    header.onClickHandler = ^{
//        __strong __typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf emit:@"com.heikki.jumptoswiftexamplepage" arg0:nil];
//    };
    header.textColor = [UIColor blackColor];
    header.text = self.headerTitle;
    header.textAlignment = NSTextAlignmentCenter;
    header.numberOfLines = 0;
    header.backgroundColor = [UIColor yellowColor];
    return header;
}

- (NSInteger)numberOfItems {
    return 20;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(50, 50);
}

- (__kindof UIView *)itemViewForIndex:(NSInteger)index {
    return [self dequeueReusableItemViewOfClass:[JTAComponentItemView class] forIndex:index];
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    [self emit:@"com.heikki.example" arg0:@(index).stringValue];
}

- (CGSize)footerSize {
    return CGSizeMake(100, 100);
}

- (__kindof UIView *)footerView {
    return [self dequeueReusableFooterViewOfClass:[JTAComponentFooterView class]];
}

@end
