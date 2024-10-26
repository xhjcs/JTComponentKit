//
//  JTBComponent.m
//  Example
//
//  Created by xinghanjie on 2024/10/21.
//

#import "JTBComponent.h"
#import "JTBComponentFooterView.h"
#import "JTBComponentHeaderView.h"
#import "JTBComponentItemView.h"

@interface JTBComponent ()

@property (nonatomic, copy) NSString *title;

@end

@implementation JTBComponent

- (void)componentDidMount {
    __weak __typeof(self) weakSelf = self;
    [self on:@"com.heikki.example"
             callback:^(JTEventHubArgs *_Nonnull args) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.title = args.arg0;
        [strongSelf reloadData];
    }];
}

- (UIEdgeInsets)inset {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)headerSize {
    return CGSizeMake(5, 5);
}

- (__kindof UIView *)headerView {
    JTBComponentHeaderView *header = [self dequeueReusableHeaderViewOfClass:[JTBComponentHeaderView class]];

    header.backgroundColor = [UIColor cyanColor];
    return header;
}

- (NSInteger)numberOfItems {
    return 20;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.size.width - 20, 44);
}

- (__kindof UIView *)itemViewForIndex:(NSInteger)index {
    JTBComponentItemView *header = [self dequeueReusableItemViewOfClass:[JTBComponentItemView class] forIndex:index];

    header.titleLabel.text = self.title ? : @"Hello World";
    header.backgroundColor = [UIColor cyanColor];
    return header;
}

- (CGSize)footerSize {
    return CGSizeMake(100, 20);
}

- (__kindof UIView *)footerView {
    JTBComponentFooterView *footer = [self dequeueReusableFooterViewOfClass:[JTBComponentFooterView class]];

    footer.backgroundColor = [UIColor cyanColor];
    return footer;
}

@end
