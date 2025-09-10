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
    NSMutableArray<NSString *> *_items;
}

- (void)setup {
    _items = [NSMutableArray new];
    for (NSInteger i = 0; i < 20; i++) {
        [_items addObject:@(i).stringValue];
    }
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
    return _items.count;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(100, 100);
}

- (__kindof UIView *)itemViewForIndex:(NSInteger)index {
    UILabel *label = [self dequeueReusableItemViewOfClass:[UILabel class] forIndex:index];
    label.backgroundColor = [UIColor redColor];
    label.text = _items[index];
    return label;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    [self emit:@"com.heikki.example" arg0:@(index).stringValue];
    NSInteger count = _items.count;
    for (NSInteger i = count; i < count + 20; i++) {
        [_items addObject:@(i).stringValue];
    }
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

- (BOOL)canMoveItemAtIndex:(NSInteger)index {
    return index != 1;
}

- (BOOL)canMoveItemToIndex:(NSInteger)destinationIndex fromComponent:(JTComponent *)sourceComponent atIndex:(NSInteger)sourceIndex {
    return destinationIndex != 18;
}

- (id)didMoveItemFromIndex:(NSInteger)index {
    NSString *data = _items[index];
    [_items removeObjectAtIndex:index];
    return data;
}

- (void)didMoveItem:(id)item toIndex:(NSInteger)index {
    [_items insertObject:item atIndex:index];
}

@end
