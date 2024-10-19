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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (void)setupViews {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self addSubview:self.collectionView];
}

- (void)assembleComponents:(NSArray<JTComponent *> *)components {
    self.components = [components copy];
    [self.components enumerateObjectsUsingBlock:^(JTComponent *_Nonnull component, NSUInteger idx, BOOL *_Nonnull stop) {
        component.section = idx;
        component.collectionView = self.collectionView;
        [component setup];
    }];
    [self.collectionView reloadData];
}

- (JTComponentCell *)findCellFromRenderView:(UIView *)renderView {
    UIView *currentView = renderView.superview;

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

    return [component collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
}

#pragma mark - Header & Footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];
    UIView *renderView = kind == UICollectionElementKindSectionHeader ? [component collectionView:collectionView viewForHeaderAtIndexPath:indexPath] : [component collectionView:collectionView viewForFooterAtIndexPath:indexPath];

    return (JTComponentReusableView *)renderView.superview;
}

#pragma mark - Cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JTComponent *component = self.components[section];

    return [component numberOfSectionsInCollectionView:collectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];

    return [component collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTComponent *component = self.components[indexPath.section];
    UIView *renderView = [component collectionView:collectionView viewForItemAtIndexPath:indexPath];

    return [self findCellFromRenderView:renderView];
}

@end
