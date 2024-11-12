//
//  JTComponentPageLifeCycleProtocol.h
//  Pods
//
//  Created by xinghanjie on 2024/11/12.
//

NS_ASSUME_NONNULL_BEGIN

@protocol JTComponentPageLifeCycleProtocol <NSObject>

- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
