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

@end

@interface JTComponentLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<JTComponentLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
