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

@implementation JTAComponent {
    NSInteger _itemsCount;
}

- (void)setup {
    _itemsCount = 20;
}

- (NSString *)description {
    return self.headerTitle;
}

- (JTComponentHeaderPinningBehavior)pinningBehaviorForHeader {
    return self.pinningBehavior;
}

- (UIEdgeInsets)insets {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGSize)headerSize {
    return self.headerTitle ? CGSizeMake(100, 100) : CGSizeZero;
}

- (__kindof UIView *)headerView {
    JTAComponentHeaderView *header = [self dequeueReusableHeaderViewOfClass:[JTAComponentHeaderView class]];
    __weak __typeof(self) weakSelf = self;
    header.onClickHandler = ^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf emit:@"com.heikki.jumptoswiftexamplepage" arg0:nil];
    };
    header.titleLabel.text = [NSString stringWithFormat:@"section: %@ - %@", [self valueForKey:@"section"], self.headerTitle];
    return header;
}

- (NSInteger)numberOfItems {
    return _itemsCount;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(50, 50);
}

- (__kindof UIView *)itemViewForIndex:(NSInteger)index {
    return [self dequeueReusableItemViewOfClass:[JTAComponentItemView class] forIndex:index];
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    [self emit:@"com.heikki.example" arg0:@(index).stringValue];
    _itemsCount += 20;
    [self reloadData];
}

- (CGSize)footerSize {
    return CGSizeMake(80, 80);
}

- (__kindof UIView *)footerView {
    return [self dequeueReusableFooterViewOfClass:[JTAComponentFooterView class]];
}

- (UIEdgeInsets)insetsForBackgroundView {
    return UIEdgeInsetsMake(115, 5, 115, 5);
}

- (NSInteger)zIndexForBackgroundView {
    return -10;
}

- (__kindof UIView *)backgroundView {
    UIView *backgroundView = [self dequeueReusableBackgroundViewOfClass:[UIView class]];
    backgroundView.backgroundColor = [UIColor magentaColor];
    return backgroundView;
}

- (void)willDisplayHeaderView:(__kindof UIView *)headerView {
    NSLog(@"willDisplayHeaderView: %@", headerView.class);
}

- (void)didEndDisplayingHeaderView:(__kindof UIView *)headerView {
    NSLog(@"didEndDisplayingHeaderView: %@", headerView.class);
}

- (void)willDisplayItemView:(__kindof UIView *)itemView atIndex:(NSInteger)index {
    NSLog(@"willDisplayItemView: %@ atIndex: %ld", itemView.class, index);
}

- (void)didEndDisplayingItemView:(__kindof UIView *)itemView atIndex:(NSInteger)index {
    NSLog(@"didEndDisplayingItemView: %@ atIndex: %ld", itemView.class, index);
}

- (void)willDisplayFooterView:(__kindof UIView *)footerView {
    NSLog(@"willDisplayHeaderView: %@", footerView.class);
}

- (void)didEndDisplayingFooterView:(__kindof UIView *)footerView {
    NSLog(@"didEndDisplayingFooterView: %@", footerView.class);
}

@end
