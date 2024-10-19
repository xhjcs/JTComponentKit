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

@property (nonatomic) BOOL isRegistedHeader;
@property (nonatomic) NSMutableSet<Class> *registedCells;
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
- (CGFloat)headerHeight {
    return 0.0;
}

- (__kindof UIView *)dequeueReusableHeaderViewWithClass:(Class)viewClass forIndex:(NSInteger)index {
    NSCAssert([viewClass isSubclassOfClass:[UIView class]], @"必须是一个View类");

    if (!self.isRegistedHeader) {
        [self.collectionView registerClass:[JTComponentReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(viewClass)];
        self.isRegistedHeader = YES;
    }

    JTComponentReusableView *reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:[NSIndexPath indexPathForItem:index inSection:self.section]];

    if (!reusableView.renderView) {
        reusableView.renderView = [viewClass new];
    }

    return reusableView.renderView;
}

- (__kindof UIView *)viewForHeaderAtIndex:(NSInteger)index {
    return [UIView new];
}

#pragma mark - Item

- (NSInteger)itemsCount {
    return 0;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(50.0, 50.0);
}

- (__kindof UIView *)dequeueReusableViewWithClass:(Class)viewClass forIndex:(NSInteger)index {
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

- (__kindof UIView *)viewForItemAtIndex:(NSInteger)index {
    return [UIView new];
}

#pragma mark - Footer
- (CGFloat)footerHeight {
    return 0.0;
}

- (__kindof UIView *)dequeueReusableFooterWithClass:(Class)viewClass forIndex:(NSInteger)index {
    NSCAssert([viewClass isSubclassOfClass:[UIView class]], @"必须是一个View类");

    if (!self.isRegistedFooter) {
        [self.collectionView registerClass:[JTComponentReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(viewClass)];
        self.isRegistedFooter = YES;
    }

    JTComponentReusableView *reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:[NSIndexPath indexPathForItem:index inSection:self.section]];

    if (!reusableView.renderView) {
        reusableView.renderView = [viewClass new];
    }

    return reusableView.renderView;
}

- (__kindof UIView *)viewForFooterAtIndex:(NSInteger)index {
    return [UIView new];
}

@end
