//
//  JTComponentsAssemblyView.h
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import <UIKit/UIKit.h>
#import "JTComponent.h"
#import "JTComponentCommunicationProtocol.h"
#import "JTComponentPageLifeCycleProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTComponentsAssemblyView : UIView

@property (nonatomic) BOOL shouldEstimateItemSize;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic, readonly) UICollectionView *collectionView;

- (void)assembleComponents:(NSArray<JTComponent *> *)components;

@end

@interface JTComponentsAssemblyView (Communication) <JTComponentCommunicationProtocol>

@end

@interface JTComponentsAssemblyView (PageLifeCycle) <JTComponentPageLifeCycleProtocol>

@end

NS_ASSUME_NONNULL_END
