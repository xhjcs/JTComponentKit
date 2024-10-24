//
//  JTComponentAssemblyView.m
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import "JTComponent.h"
#import "JTComponent_Private.h"
#import "JTComponentAssemblyView.h"
#import "JTComponentCell.h"
#import "JTComponentReusableView.h"

@interface JTComponentAssemblyView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic) UICollectionViewFlowLayout *layout;
@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic) NSArray<JTComponent *> *components;

@end

@implementation JTComponentAssemblyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }

    return self;
}

- (void)setupViews {
    self.layout = [UICollectionViewFlowLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.collectionView];
    [NSLayoutConstraint activateConstraints:@[
         [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
         [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
         [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
         [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)assembleComponents:(NSArray<JTComponent *> *)components {
    JTEventHub *eventHub = [JTEventHub new];

    self.components = [components copy];
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        component.section = idx;
        component.collectionView = self.collectionView;
        component.eventHub = eventHub;
        [component setup];
    }];
    [self.collectionView reloadData];
}

- (void)setShouldEstimateItemSize:(BOOL)shouldEstimateItemSize {
    self.layout.estimatedItemSize = shouldEstimateItemSize ? UICollectionViewFlowLayoutAutomaticSize : CGSizeZero;
}

- (BOOL)shouldEstimateItemSize {
    return !CGSizeEqualToSize(self.layout.estimatedItemSize, CGSizeZero);
}

- (void)setComponentHeadersPinToVisibleBounds:(BOOL)componentHeadersPinToVisibleBounds {
    self.layout.sectionHeadersPinToVisibleBounds = componentHeadersPinToVisibleBounds;
}

- (BOOL)componentHeadersPinToVisibleBounds {
    return self.layout.sectionHeadersPinToVisibleBounds;
}

- (void)setComponentFootersPinToVisibleBounds:(BOOL)componentFootersPinToVisibleBounds {
    self.layout.sectionFootersPinToVisibleBounds = componentFootersPinToVisibleBounds;
}

- (BOOL)componentFootersPinToVisibleBounds {
    return self.layout.sectionFootersPinToVisibleBounds;
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    self.layout.scrollDirection = scrollDirection;
}

- (UICollectionViewScrollDirection)scrollDirection {
    return self.layout.scrollDirection;
}

- (void)setBounces:(BOOL)bounces {
    self.collectionView.bounces = bounces;
}

- (BOOL)bounces {
    return self.collectionView.bounces;
}

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    self.collectionView.pagingEnabled = pagingEnabled;
}

- (BOOL)pagingEnabled {
    return self.collectionView.pagingEnabled;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.collectionView.scrollEnabled = scrollEnabled;
}

- (BOOL)scrollEnabled {
    return self.collectionView.scrollEnabled;
}

- (JTComponentCell *)findCellFromRenderView:(UIView *)renderView {
    UIView *currentView = renderView.superview;

    while (![currentView isMemberOfClass:[JTComponentCell class]]) {
        currentView = currentView.superview;
    }
    return (JTComponentCell *)currentView;
}

#pragma mark - Section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.components.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component inset];
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
    JTComponent *component = self.components[indexPath.section];

    if (elementKind == UICollectionElementKindSectionHeader) {
        [component willDisplayHeaderView];
    } else {
        [component willDisplayFooterView];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];
    UIView *renderView = kind == UICollectionElementKindSectionHeader ? [component headerViewForIndex:indexPath.item] : [component footerViewForIndex:indexPath.item];

    return (JTComponentReusableView *)renderView.superview;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];

    if (elementKind == UICollectionElementKindSectionHeader) {
        [component didEndDisplayingHeaderView];
    } else {
        [component didEndDisplayingFooterView];
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

    [component willDisplayItemView];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];
    UIView *renderView = [component itemViewForIndex:indexPath.item];

    return [self findCellFromRenderView:renderView];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];

    [component didEndDisplayingItemView];
}

@end
