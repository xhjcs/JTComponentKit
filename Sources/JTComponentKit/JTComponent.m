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
@property (nonatomic) BOOL isRegistedHeader;
@property (nonatomic) NSMutableSet<Class> *registedCells;
@property (nonatomic) NSInteger footerIndex;
@property (nonatomic) BOOL isRegistedFooter;

@end

@implementation JTComponent

- (instancetype)init {
    if (self = [super init]) {
        _registedCells = [NSMutableSet new];
    }

    return self;
}

- (void)setup {
}

- (void)reloadData {
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:self.section]];
}

- (CGSize)size {
    return self.collectionView.bounds.size;
}

#pragma mark - Section
- (UIEdgeInsets)inset {
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

    if (!self.isRegistedHeader) {
        [self.collectionView registerClass:[JTComponentReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(viewClass)];
        self.isRegistedHeader = YES;
    }

    JTComponentReusableView *reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:[NSIndexPath indexPathForItem:self.headerIndex inSection:self.section]];

    if (!reusableView.renderView) {
        reusableView.renderView = [viewClass new];
    }

    return reusableView.renderView;
}

- (void)willDisplayHeaderView {
}

- (__kindof UIView *)headerViewForIndex:(NSInteger)index {
    self.headerIndex = index;
    return [self headerView];
}

- (__kindof UIView *)headerView {
    return [self dequeueReusableHeaderViewOfClass:[UIView class]];
}

- (void)didEndDisplayingHeaderView {
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

    if (![self.registedCells containsObject:viewClass]) {
        [self.collectionView registerClass:[JTComponentCell class] forCellWithReuseIdentifier:NSStringFromClass(viewClass)];

        if (viewClass) {
            [self.registedCells addObject:viewClass];
        }
    }

    JTComponentCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:[NSIndexPath indexPathForItem:index inSection:self.section]];

    if (!cell.renderView) {
        cell.renderView = [viewClass new];
    }

    return cell.renderView;
}

- (void)willDisplayItemView {
}

- (__kindof UIView *)itemViewForIndex:(NSInteger)index {
    return [self dequeueReusableItemViewOfClass:[UIView class] forIndex:index];
}

- (void)didEndDisplayingItemView {
}

#pragma mark - Footer
- (CGSize)footerSize {
    return CGSizeZero;
}

- (__kindof UIView *)dequeueReusableFooterViewOfClass:(Class)viewClass {
    NSCAssert([viewClass isSubclassOfClass:[UIView class]], @"必须是一个View类");

    if (!self.isRegistedFooter) {
        [self.collectionView registerClass:[JTComponentReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(viewClass)];
        self.isRegistedFooter = YES;
    }

    JTComponentReusableView *reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:[NSIndexPath indexPathForItem:self.footerIndex inSection:self.section]];

    if (!reusableView.renderView) {
        reusableView.renderView = [viewClass new];
    }

    return reusableView.renderView;
}

- (void)willDisplayFooterView {
}

- (__kindof UIView *)footerViewForIndex:(NSInteger)index {
    self.footerIndex = index;
    return [self footerView];
}

- (__kindof UIView *)footerView {
    return [self dequeueReusableFooterViewOfClass:[UIView class]];
}

- (void)didEndDisplayingFooterView {
}

@end
