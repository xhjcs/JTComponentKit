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
        if (@available(iOS 14.0, tvOS 14.0, *)) {
            _registedCells = [NSMutableSet new];
        }
    }

    return self;
}

- (void)setup {
}

- (void)reloadData {
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:self.section]];
}

#pragma mark - Section
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

#pragma mark - Header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (__kindof UIView *)dequeueReusableHeaderViewWithClass:(Class)viewClass forIndexPath:(NSIndexPath *)indexPath {
    NSCAssert([viewClass isSubclassOfClass:[UIView class]], @"必须是一个View类");
    JTComponentReusableView *reusableView = nil;

//    if (@available(iOS 14.0, tvOS 14.0, *)) {
//        UICollectionViewSupplementaryRegistration *registration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[JTComponentReusableView class]
//                                                                                                                                    elementKind:UICollectionElementKindSectionHeader
//                                                                                                                           configurationHandler:^(__kindof UICollectionReusableView *_Nonnull supplementaryView, NSString *_Nonnull elementKind, NSIndexPath *_Nonnull indexPath) {
//        }];
//        reusableView = [self.collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:registration forIndexPath:indexPath];
//    } else {
        if (!self.isRegistedHeader) {
            [self.collectionView registerClass:[JTComponentReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(viewClass)];
            self.isRegistedHeader = YES;
        }

        reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:indexPath];
//    }

    if (!reusableView.renderView) {
        reusableView.renderView = [viewClass new];
    }

    return reusableView.renderView;
}

- (__kindof UIView *)collectionView:(UICollectionView *)collectionView viewForHeaderAtIndexPath:(NSIndexPath *)indexPath {
    return [UIView new];
}

#pragma mark - Item
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50.0, 50.0);
}

- (__kindof UIView *)dequeueReusableViewWithClass:(Class)viewClass forIndexPath:(NSIndexPath *)indexPath {
    NSCAssert([viewClass isSubclassOfClass:[UIView class]], @"必须是一个View类");
    JTComponentCell *cell = nil;

//    if (@available(iOS 14.0, tvOS 14.0, *)) {
//        UICollectionViewCellRegistration *registration = [UICollectionViewCellRegistration registrationWithCellClass:[JTComponentCell class]
//                                                                                                configurationHandler:^(__kindof UICollectionViewCell *_Nonnull cell, NSIndexPath *_Nonnull indexPath, id _Nonnull item) {
//        }];
//        cell = [self.collectionView dequeueConfiguredReusableCellWithRegistration:registration forIndexPath:indexPath item:indexPath];
//    } else {
        if (![self.registedCells containsObject:viewClass]) {
            [self.collectionView registerClass:[JTComponentCell class] forCellWithReuseIdentifier:NSStringFromClass(viewClass)];

            if (viewClass) {
                [self.registedCells addObject:viewClass];
            }
        }

        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:indexPath];
//    }

    if (!cell.renderView) {
        cell.renderView = [viewClass new];
    }

    return cell.renderView;
}

- (__kindof UIView *)collectionView:(UICollectionView *)collectionView viewForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [UIView new];
}

#pragma mark - Footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (__kindof UIView *)dequeueReusableFooterWithClass:(Class)viewClass forIndexPath:(NSIndexPath *)indexPath {
    NSCAssert([viewClass isSubclassOfClass:[UIView class]], @"必须是一个View类");
    JTComponentReusableView *reusableView = nil;

//    if (@available(iOS 14.0, tvOS 14.0, *)) {
//        UICollectionViewSupplementaryRegistration *registration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[JTComponentReusableView class]
//                                                                                                                                    elementKind:UICollectionElementKindSectionFooter
//                                                                                                                           configurationHandler:^(__kindof UICollectionReusableView *_Nonnull supplementaryView, NSString *_Nonnull elementKind, NSIndexPath *_Nonnull indexPath) {
//        }];
//        reusableView = [self.collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:registration forIndexPath:indexPath];
//    } else {
        if (!self.isRegistedFooter) {
            [self.collectionView registerClass:[JTComponentReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(viewClass)];
            self.isRegistedFooter = YES;
        }

        reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:indexPath];
//    }

    if (!reusableView.renderView) {
        reusableView.renderView = [viewClass new];
    }

    return reusableView.renderView;
}

- (__kindof UIView *)collectionView:(UICollectionView *)collectionView viewForFooterAtIndexPath:(NSIndexPath *)indexPath {
    return [UIView new];
}

@end
