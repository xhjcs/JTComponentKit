//
//  JTComponentsAssemblyView.h
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import <UIKit/UIKit.h>
#import "JTCommunicationProtocol.h"
#import "JTComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTComponentsAssemblyView : UIView <JTCommunicationProtocol>

@property (nonatomic, readonly) UICollectionViewFlowLayout *layout;
@property (nonatomic, readonly) UICollectionView *collectionView;

- (void)assembleComponents:(NSArray<JTComponent *> *)components;

@end

NS_ASSUME_NONNULL_END
