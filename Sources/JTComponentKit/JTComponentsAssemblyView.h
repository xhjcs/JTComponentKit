//
//  JTComponentsAssemblyView.h
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import <UIKit/UIKit.h>
#import "JTComponent.h"
#import "JTCommunicationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTComponentsAssemblyView : UIView <JTCommunicationProtocol>

@property (nonatomic) BOOL shouldEstimateItemSize;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic) BOOL bounces;
@property (nonatomic) BOOL pagingEnabled;
@property (nonatomic) BOOL scrollEnabled;

@property (nonatomic) BOOL componentHeadersPinToVisibleBounds;
@property (nonatomic) BOOL componentFootersPinToVisibleBounds;

- (void)assembleComponents:(NSArray<JTComponent *> *)components;

@end

NS_ASSUME_NONNULL_END
