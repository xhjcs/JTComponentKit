//
//  JTComponentsAssemblyView.m
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import "JTCollectionView.h"
#import "JTComponent.h"
#import "JTComponent_Private.h"
#import "JTComponentCell.h"
#import "JTComponentLayout.h"
#import "JTComponentReusableView.h"
#import "JTComponentsAssemblyView.h"

@interface JTComponentsAssemblyView (Pin) <JTComponentLayoutDelegate>

@end

@interface JTComponentsAssemblyView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic) JTComponentLayout *layout;
@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic) JTEventHub *eventHub;
@property (nonatomic, copy) NSArray<JTComponent *> *components;

@property (nonatomic) NSMutableSet<JTEventHubSubscription *> *eventSubscriptions;

@property (nonatomic) UILongPressGestureRecognizer *interactiveMovementGesture;
@property (nonatomic) CGPoint interactiveMovementGestureTouchOffset;

@end

@implementation JTComponentsAssemblyView

@synthesize allowsInteractiveMovement = _allowsInteractiveMovement;

- (void)dealloc {
    [self offEvents];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _eventHub = [JTEventHub new];
        _eventSubscriptions = [NSMutableSet new];
        [self setupViews];
    }

    return self;
}

- (void)setupViews {
    self.layout = [JTComponentLayout new];
    self.layout.delegate = self;
    self.collectionView = [[JTCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView registerClass:[JTComponentReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:JTComponentFakeHeaderReuseIdentifier];
    [self addSubview:self.collectionView];
    [NSLayoutConstraint activateConstraints:@[
         [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
         [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
         [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
         [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    self.layout.scrollDirection = scrollDirection;
}

- (UICollectionViewScrollDirection)scrollDirection {
    return self.layout.scrollDirection;
}

- (void)assembleComponents:(NSArray<JTComponent *> *)components {
#if DEBUG
    NSSet<JTComponent *> *uniqueElements = [NSSet setWithArray:components];
    NSCAssert(uniqueElements.count == components.count, @"不要传入相同的两个Component对象");
#endif
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        [component componentWillUnmount];
    }];
    self.components = components;
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        component.section = idx;
        component.layout = self.layout;
        component.collectionView = self.collectionView;
        component.eventHub = self.eventHub;

        if (!component.hasSetup) {
            [component setup];
            component.hasSetup = YES;
        }

        [component componentDidMount];
    }];
    [self.collectionView reloadData];
}

- (JTComponentCell *)findCellFromRenderView:(UIView *)renderView {
    UIView *currentView = renderView.superview.superview;

    while (![currentView isMemberOfClass:[JTComponentCell class]])
        currentView = currentView.superview;
    return (JTComponentCell *)currentView;
}

#pragma mark - Section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.components.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component insets];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component minimumLineSpacing];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component minimumInteritemSpacing];
}

#pragma mark - Header & Footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component headerSize];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component footerSize];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (elementKind == JTComponentElementKindSectionHeader) {
        JTComponent *component = self.components[indexPath.section];
        [component willDisplayHeaderView:((JTComponentReusableView *)view).renderView];
    } else if (elementKind == UICollectionElementKindSectionFooter) {
        JTComponent *component = self.components[indexPath.section];
        [component willDisplayFooterView:((JTComponentReusableView *)view).renderView];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:JTComponentFakeHeaderReuseIdentifier forIndexPath:indexPath];
    }

    JTComponent *component = self.components[indexPath.section];
    UIView *renderView = nil;

    if (kind == JTComponentElementKindSectionHeader) {
        renderView = [component headerViewForIndex:indexPath.item];
    } else if (kind == UICollectionElementKindSectionFooter) {
        renderView = [component footerViewForIndex:indexPath.item];
    } else if (kind == JTComponentElementKindSectionBackground) {
        renderView = [component backgroundViewForIndex:indexPath.item];
    } else {
        NSString *desc = [NSString stringWithFormat:@"有未处理的补充视图类型：%@", kind];
        NSCAssert(NO, desc);
    }

    NSCParameterAssert(renderView);
    return (JTComponentReusableView *)renderView.superview;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (elementKind == JTComponentElementKindSectionHeader) {
        JTComponent *component = self.components[indexPath.section];
        [component didEndDisplayingHeaderView:((JTComponentReusableView *)view).renderView];
    } else if (elementKind == UICollectionElementKindSectionFooter) {
        JTComponent *component = self.components[indexPath.section];
        [component didEndDisplayingFooterView:((JTComponentReusableView *)view).renderView];
    }
}

#pragma mark - Cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component numberOfItems];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];

    return [component sizeForItemAtIndex:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];

    [component willDisplayItemView:((JTComponentCell *)cell).renderView atIndex:indexPath.item];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];
    UIView *renderView = [component itemViewForIndex:indexPath.item];

    return [self findCellFromRenderView:renderView];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];

    [component didSelectItemAtIndex:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];

    [component didEndDisplayingItemView:((JTComponentCell *)cell).renderView atIndex:indexPath.item];
}

#pragma mark - Private
- (void)offEvents {
    [self.eventSubscriptions enumerateObjectsUsingBlock:^(JTEventHubSubscription *_Nonnull subscription, BOOL *_Nonnull stop) {
        [subscription remove];
    }];
    [self.eventSubscriptions removeAllObjects];
}

@end

@implementation JTComponentsAssemblyView (Communication)

- (void)on:(NSString *)event callback:(void (^)(JTEventHubArgs *_Nonnull))callback {
    JTEventHubSubscription *subscription = [self.eventHub on:event callback:callback];

    NSCParameterAssert(subscription);

    if (subscription) {
        [self.eventSubscriptions addObject:subscription];
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

@interface JTComponentsAssemblyView (Scroll) <UIScrollViewDelegate>

@end

@implementation JTComponentsAssemblyView (Scroll)

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([component respondsToSelector:@selector(scrollViewDidScroll:)]) {
            [component scrollViewDidScroll:scrollView];
        }
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([component respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
            [component scrollViewWillBeginDragging:scrollView];
        }
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([component respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
            [component scrollViewWillEndDragging:scrollView
                                    withVelocity:velocity
                             targetContentOffset:targetContentOffset];
        }
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([component respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
            [component scrollViewDidEndDragging:scrollView
                                 willDecelerate:decelerate];
        }
    }];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([component respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
            [component scrollViewWillBeginDecelerating:scrollView];
        }
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([component respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
            [component scrollViewDidEndDecelerating:scrollView];
        }
    }];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([component respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
            [component scrollViewDidEndScrollingAnimation:scrollView];
        }
    }];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([component respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
            [component scrollViewDidScrollToTop:scrollView];
        }
    }];
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([component respondsToSelector:@selector(scrollViewDidChangeAdjustedContentInset:)]) {
            [component scrollViewDidChangeAdjustedContentInset:scrollView];
        }
    }];
}

@end

@interface JTComponentsAssemblyView (Movable)

@end

@implementation JTComponentsAssemblyView (Movable)

- (void)setAllowsInteractiveMovement:(BOOL)allowsInteractiveMovement {
    _allowsInteractiveMovement = allowsInteractiveMovement;

    if (allowsInteractiveMovement) {
        self.interactiveMovementGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleInteractiveMovementGesture:)];
        [self.collectionView addGestureRecognizer:self.interactiveMovementGesture];
    } else {
        [self.collectionView removeGestureRecognizer:self.interactiveMovementGesture];
        self.interactiveMovementGesture = nil;
    }
}

- (BOOL)allowsInteractiveMovement {
    return _allowsInteractiveMovement;
}

- (void)handleInteractiveMovementGesture:(UILongPressGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:[sender locationInView:sender.view]];

            if (selectedIndexPath) {
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:selectedIndexPath];

                if (cell) {
                    CGPoint touchInCell = [sender locationInView:cell];
                    self.interactiveMovementGestureTouchOffset = CGPointMake(cell.bounds.size.width / 2 - touchInCell.x,
                                                                             cell.bounds.size.height / 2 - touchInCell.y);
                }

                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
            }
        }
        break;

        case UIGestureRecognizerStateChanged: {
            CGPoint location = [sender locationInView:sender.view];
            CGPoint touchOffset = self.interactiveMovementGestureTouchOffset;
            CGPoint adjustedLocation = CGPointMake(location.x + touchOffset.x,
                                                   location.y + touchOffset.y);
            [self.collectionView updateInteractiveMovementTargetPosition:adjustedLocation];
        }
        break;

        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
        }
        break;

        default: {
            [self.collectionView cancelInteractiveMovement];
        }
        break;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];

    return [component canMoveItemAtIndex:indexPath.item];
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveOfItemFromOriginalIndexPath:(NSIndexPath *)originalIndexPath atCurrentIndexPath:(NSIndexPath *)currentIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    JTComponent *fromComponent = self.components[originalIndexPath.section];
    JTComponent *toComponent = self.components[proposedIndexPath.section];

    if ([toComponent canMoveItemToIndex:proposedIndexPath.item fromComponent:fromComponent atIndex:originalIndexPath.item]) {
        return proposedIndexPath;
    }

    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    JTComponent *fromComponent = self.components[sourceIndexPath.section];
    JTComponent *toComponent = self.components[destinationIndexPath.section];

    id data = [fromComponent didMoveItemFromIndex:sourceIndexPath.item];

    [toComponent didMoveItem:data toIndex:destinationIndexPath.item];
}

@end

@implementation JTComponentsAssemblyView (PageLifeCycle)

- (void)pageWillAppear:(BOOL)animated {
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        [component pageWillAppear:animated];
    }];
}

- (void)pageDidAppear:(BOOL)animated {
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        [component pageDidAppear:animated];
    }];
}

- (void)pageWillDisappear:(BOOL)animated {
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        [component pageWillDisappear:animated];
    }];
}

- (void)pageDidDisappear:(BOOL)animated {
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        [component pageDidDisappear:animated];
    }];
}

@end

@implementation JTComponentsAssemblyView (Pin)

- (JTComponentHeaderPinningBehavior)collectionView:(UICollectionView *)collectionView pinningBehaviorForHeaderInSection:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component pinningBehaviorForHeader];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView insetsForBackgroundViewInSection:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component insetsForBackgroundView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView zIndexForBackgroundViewInSection:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component zIndexForBackgroundView];
}

@end
