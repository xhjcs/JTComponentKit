//
//  JTComponent_Private.h
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import "JTComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTComponent ()

@property (nonatomic) JTEventHub *eventHub;

@property (nonatomic) NSInteger section;
@property (nonatomic) UICollectionView *collectionView;

- (__kindof UIView *)headerViewForIndex:(NSInteger)index;
- (__kindof UIView *)footerViewForIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
