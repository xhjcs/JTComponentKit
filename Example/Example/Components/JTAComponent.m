//
//  JTAComponent.m
//  Example
//
//  Created by xinghanjie on 2024/10/15.
//

#import "JTAComponent.h"
#import "JTAComponentHeaderView.h"
#import "JTAComponentItemView.h"
#import "JTAComponentFooterView.h"

@implementation JTAComponent

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 44, 20, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 100);
}

- (__kindof UIView *)collectionView:(UICollectionView *)collectionView viewForHeaderAtIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableHeaderViewWithClass:[JTAComponentHeaderView class] forIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 100;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 100);
}

- (__kindof UIView *)collectionView:(UICollectionView *)collectionView viewForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableViewWithClass:[JTAComponentItemView class] forIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(200, 100);
}

- (__kindof UIView *)collectionView:(UICollectionView *)collectionView viewForFooterAtIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableFooterWithClass:[JTAComponentFooterView class] forIndexPath:indexPath];
}

@end
