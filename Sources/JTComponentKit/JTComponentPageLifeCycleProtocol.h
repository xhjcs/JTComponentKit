//
//  JTComponentPageLifeCycleProtocol.h
//  Pods
//
//  Created by xinghanjie on 2024/11/12.
//

NS_ASSUME_NONNULL_BEGIN

@protocol JTComponentPageLifeCycleProtocol <NSObject>

- (void)pageWillAppear:(BOOL)animated;
- (void)pageDidAppear:(BOOL)animated;
- (void)pageWillDisappear:(BOOL)animated;
- (void)pageDidDisappear:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
