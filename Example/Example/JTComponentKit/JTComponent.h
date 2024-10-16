//
//  JTComponent.h
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTComponent : NSObject

- (void)reloadData;

#pragma mark - Section
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

#pragma mark - Header
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
- (__kindof UIView *)dequeueReusableHeaderViewWithClass:(Class)viewClass forIndexPath:(NSIndexPath *)indexPath;
- (__kindof UIView *)collectionView:(UICollectionView *)collectionView viewForHeaderAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Item
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (__kindof UIView *)dequeueReusableViewWithClass:(Class)viewClass forIndexPath:(NSIndexPath *)indexPath;
- (__kindof UIView *)collectionView:(UICollectionView *)collectionView viewForItemAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
- (__kindof UIView *)dequeueReusableFooterWithClass:(Class)viewClass forIndexPath:(NSIndexPath *)indexPath;
- (__kindof UIView *)collectionView:(UICollectionView *)collectionView viewForFooterAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
