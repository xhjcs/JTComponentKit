//
//  JTComponent.m
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/16.
//

#import "JTComponent.h"
#import "JTComponent_Private.h"
#import "JTComponentCell.h"
#import "JTComponentReusableView.h"

@interface JTComponent ()

@property (nonatomic) NSInteger headerIndex;
@property (nonatomic) NSInteger footerIndex;
@property (nonatomic) NSInteger backgroundViewIndex;

@property (nonatomic) NSMutableSet<NSString *> *eventHubIdentifiers;

@end

@implementation JTComponent

#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        _eventHubIdentifiers = [NSMutableSet new];
    }

    return self;
}

- (void)setup {
}

- (void)componentDidMount {
}

- (void)componentWillUnmount {
    [self offEvents];
}

- (void)dealloc {
    [self offEvents];
}

#pragma mark - Public
- (CGSize)size {
    return self.collectionView.bounds.size;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)scrollToSelf:(BOOL)animated {
    CGPoint offset = [self.layout offsetForSection:self.section];

    [self.collectionView setContentOffset:offset animated:animated];
}

#pragma mark - Section
- (UIEdgeInsets)insets {
    return UIEdgeInsetsZero;
}

- (CGFloat)minimumLineSpacing {
    return 10.0;
}

- (CGFloat)minimumInteritemSpacing {
    return 10.0;
}

#pragma mark - Header
- (CGSize)headerSize {
    return CGSizeZero;
}

- (__kindof UIView *)dequeueReusableHeaderViewOfClass:(Class)viewClass {
    NSCAssert([viewClass isSubclassOfClass:[UIView class]], @"必须是一个View类");

    JTComponentReusableView *reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:JTComponentElementKindSectionHeader withReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:[NSIndexPath indexPathForItem:self.headerIndex inSection:self.section]];

    if (!reusableView.renderView) {
        reusableView.renderView = [viewClass new];
    }

    return reusableView.renderView;
}

- (void)willDisplayHeaderView:(__kindof UIView *)headerView {
}

- (__kindof UIView *)headerViewForIndex:(NSInteger)index {
    self.headerIndex = index;
    return [self headerView];
}

- (__kindof UIView *)headerView {
    return [self dequeueReusableHeaderViewOfClass:[UIView class]];
}

- (void)didEndDisplayingHeaderView:(__kindof UIView *)headerView {
}

#pragma mark - Item

- (NSInteger)numberOfItems {
    return 0;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeZero;
}

- (__kindof UIView *)dequeueReusableItemViewOfClass:(Class)viewClass forIndex:(NSInteger)index {
    NSCAssert([viewClass isSubclassOfClass:[UIView class]], @"必须是一个View类");

    JTComponentCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:[NSIndexPath indexPathForItem:index inSection:self.section]];

    if (!cell.renderView) {
        cell.renderView = [viewClass new];
    }

    return cell.renderView;
}

- (void)willDisplayItemView:(__kindof UIView *)itemView atIndex:(NSInteger)index {
}

- (__kindof UIView *)itemViewForIndex:(NSInteger)index {
    return [self dequeueReusableItemViewOfClass:[UIView class] forIndex:index];
}

- (void)didSelectItemAtIndex:(NSInteger)index {
}

- (void)didEndDisplayingItemView:(__kindof UIView *)itemView atIndex:(NSInteger)index {
}

#pragma mark - Footer
- (CGSize)footerSize {
    return CGSizeZero;
}

- (__kindof UIView *)dequeueReusableFooterViewOfClass:(Class)viewClass {
    NSCAssert([viewClass isSubclassOfClass:[UIView class]], @"必须是一个View类");

    JTComponentReusableView *reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:[NSIndexPath indexPathForItem:self.footerIndex inSection:self.section]];

    if (!reusableView.renderView) {
        reusableView.renderView = [viewClass new];
    }

    return reusableView.renderView;
}

- (void)willDisplayFooterView:(__kindof UIView *)footerView {
}

- (__kindof UIView *)footerViewForIndex:(NSInteger)index {
    self.footerIndex = index;
    return [self footerView];
}

- (__kindof UIView *)footerView {
    return [self dequeueReusableFooterViewOfClass:[UIView class]];
}

- (void)didEndDisplayingFooterView:(__kindof UIView *)footerView {
}

#pragma mark - Background
- (UIEdgeInsets)insetsForBackgroundView {
    return UIEdgeInsetsZero;
}

- (NSInteger)zIndexForBackgroundView {
    return 0;
}

- (__kindof UIView *)dequeueReusableBackgroundViewOfClass:(Class)viewClass {
    NSCAssert([viewClass isSubclassOfClass:[UIView class]], @"必须是一个View类");

    JTComponentReusableView *reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:JTComponentElementKindSectionBackground withReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:[NSIndexPath indexPathForItem:self.backgroundViewIndex inSection:self.section]];

    if (!reusableView.renderView) {
        reusableView.renderView = [viewClass new];
    }

    return reusableView.renderView;
}

- (__kindof UIView *)backgroundViewForIndex:(NSInteger)index {
    self.backgroundViewIndex = index;
    return [self backgroundView];
}

- (__kindof UIView *)backgroundView {
    return [self dequeueReusableBackgroundViewOfClass:[UIView class]];
}

#pragma mark - Private
- (void)offEvents {
    [self.eventHubIdentifiers enumerateObjectsUsingBlock:^(NSString *_Nonnull identifier, BOOL *_Nonnull stop) {
        [self.eventHub offByIdentifier:identifier];
    }];
    [self.eventHubIdentifiers removeAllObjects];
}

@end

@implementation JTComponent (Communication)

- (void)on:(NSString *)event callback:(void (^)(JTEventHubArgs *_Nonnull))callback {
    NSString *identifier = [self.eventHub on:event callback:callback];

    NSCParameterAssert(identifier);

    if (identifier) {
        [self.eventHubIdentifiers addObject:identifier];
    }
}

- (void)emit:(NSString *)event arg0:(nullable id)arg0 {
    [self.eventHub emit:event arg0:arg0];
}

- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 {
    [self.eventHub emit:event arg0:arg0 arg1:arg1];
}

- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 {
    [self.eventHub emit:event arg0:arg0 arg1:arg1 arg2:arg2];
}

- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 {
    [self.eventHub emit:event arg0:arg0 arg1:arg1 arg2:arg2 arg3:arg3];
}

- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 {
    [self.eventHub emit:event arg0:arg0 arg1:arg1 arg2:arg2 arg3:arg3 arg4:arg4];
}

- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 arg5:(nullable id)arg5 {
    [self.eventHub emit:event arg0:arg0 arg1:arg1 arg2:arg2 arg3:arg3 arg4:arg4 arg5:arg5];
}

@end

@implementation JTComponent (Movable)

- (BOOL)canMoveItemAtIndex:(NSInteger)index {
    return NO;
}

- (BOOL)canMoveItemToIndex:(NSInteger)destinationIndex
             fromComponent:(JTComponent *)sourceComponent
                   atIndex:(NSInteger)sourceIndex {
    return self == sourceComponent;
}

- (id)didMoveItemFromIndex:(NSInteger)index {
    return nil;
}

- (void)didMoveItem:(id)item toIndex:(NSInteger)index {
}

@end

@implementation JTComponent (PageLifeCycle)

- (void)pageWillAppear:(BOOL)animated {
}

- (void)pageDidAppear:(BOOL)animated {
}

- (void)pageWillDisappear:(BOOL)animated {
}

- (void)pageDidDisappear:(BOOL)animated {
}

@end

@implementation JTComponent (Scroll)

@end

@implementation JTComponent (Pin)

- (JTComponentHeaderPinningBehavior)pinningBehaviorForHeader {
    return JTComponentHeaderPinningBehaviorNone;
}

@end
