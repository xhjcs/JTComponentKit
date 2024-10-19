//
//  JTAComponent.m
//  Example
//
//  Created by xinghanjie on 2024/10/15.
//

#import "JTAComponent.h"

@implementation JTAComponent

- (void)setup {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 100);
}

- (__kindof UIView *)collectionView:(UICollectionView *)collectionView viewForHeaderAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}



@end
