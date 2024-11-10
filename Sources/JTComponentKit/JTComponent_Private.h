//
//  JTComponent_Private.h
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import "JTComponent.h"
#import "JTComponentLayout.h"
#import "JTEventHub.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTComponent ()

@property (nonatomic) JTEventHub *eventHub;

@property (nonatomic) NSInteger section;
@property (nonatomic) JTComponentLayout *layout;
@property (nonatomic) UICollectionView *collectionView;

- (__kindof UIView *)headerViewForIndex:(NSInteger)index;
- (__kindof UIView *)footerViewForIndex:(NSInteger)index;
- (__kindof UIView *)backgroundViewForIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
