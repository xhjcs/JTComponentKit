//
//  JTComponentsAssemblyView.m
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import "JTComponent.h"
#import "JTComponent_Private.h"
#import "JTComponentCell.h"
#import "JTComponentReusableView.h"
#import "JTComponentsAssemblyView.h"

static const NSString *const kEventNameKey = @"event";
static const NSString *const kEventIdentifierKey = @"identifier";

@interface JTComponentsAssemblyView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic) UICollectionViewFlowLayout *layout;
@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic) JTEventHub *eventHub;
@property (nonatomic) NSArray<JTComponent *> *components;

@property (nonatomic) NSMutableSet<NSDictionary *> *eventHubTokens;

@end

@implementation JTComponentsAssemblyView

- (void)dealloc {
    [self offEvents];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _eventHub = [JTEventHub new];
        _eventHubTokens = [NSMutableSet new];
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
    [components enumerateObjectsUsingBlock:^(JTComponent * _Nonnull component, NSUInteger idx, BOOL * _Nonnull stop) {
        [component componentWillUnmount];
    }];
    self.components = [components copy];
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        component.section = idx;
        component.collectionView = self.collectionView;
        component.eventHub = self.eventHub;
        [component componentDidMount];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];
    
    [component didSelectItemAtIndex:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];

    [component didEndDisplayingItemView];
}

#pragma mark - JTCommunicationProtocol
- (void)on:(NSString *)event callback:(void (^)(JTEventHubArgs * _Nonnull))callback {
    NSString *identifier = [self.eventHub on:event callback:callback];
    NSMutableDictionary *token = [NSMutableDictionary new];
    token[kEventNameKey] = event;
    token[kEventIdentifierKey] = identifier;
    [self.eventHubTokens addObject:[token copy]];
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

#pragma mark - Private
- (void)offEvents {
    [self.eventHubTokens enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *eventName = obj[kEventNameKey];
        NSString *identifier = obj[kEventIdentifierKey];
        NSCParameterAssert(eventName);
        NSCParameterAssert(identifier);
        [self.eventHub off:eventName identifier:identifier];
    }];
}

@end