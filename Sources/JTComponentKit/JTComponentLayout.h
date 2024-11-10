//
//  JTComponentLayout.h
//  JTComponentKit
//
//  Created by xinghanjie on 2024/11/5.
//

#import <UIKit/UIKit.h>
#import "JTComponentDefines.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JTComponentLayoutDelegate <NSObject>

- (JTComponentHeaderPinningBehavior)collectionView:(UICollectionView *)collectionView pinningBehaviorForHeaderInSection:(NSInteger)section;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView insetForBackgroundViewInSection:(NSInteger)section;
- (NSInteger)collectionView:(UICollectionView *)collectionView zIndexForBackgroundViewInSection:(NSInteger)section;

@end

@interface JTComponentLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<JTComponentLayoutDelegate> delegate;

- (CGPoint)offsetForSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
