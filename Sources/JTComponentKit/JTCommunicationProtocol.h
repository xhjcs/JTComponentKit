//
//  JTCommunicationProtocol.h
//  Pods
//
//  Created by xinghanjie on 2024/10/26.
//

#import "JTEventHubArgs.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JTCommunicationProtocol <NSObject>

- (void)on:(NSString *)event callback:(void (^)(JTEventHubArgs *args))callback;

- (void)emit:(NSString *)event arg0:(nullable id)arg0;
- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1;
- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2;
- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3;
- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4;
- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 arg5:(nullable id)arg5;

@end

NS_ASSUME_NONNULL_END
