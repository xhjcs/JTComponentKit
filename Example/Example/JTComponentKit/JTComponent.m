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

@implementation JTComponent

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
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

#pragma mark - Header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (__kindof UIView *)dequeueReusableHeaderViewWithClass:(Class)viewClass forIndexPath:(NSIndexPath *)indexPath {
    JTComponentReusableView *reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:indexPath];

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
    return CGSizeZero;
}

- (__kindof UIView *)dequeueReusableViewWithClass:(Class)viewClass forIndexPath:(NSIndexPath *)indexPath {
    JTComponentCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(viewClass) forIndexPath:indexPath];

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
    return [UIView new];
}

- (__kindof UIView *)collectionView:(UICollectionView *)collectionView viewForFooterAtIndexPath:(NSIndexPath *)indexPath {
    return [UIView new];
}

@end
