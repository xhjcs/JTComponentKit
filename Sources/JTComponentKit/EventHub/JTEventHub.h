//
//  JTEventHub.h
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/19.
//

#import <Foundation/Foundation.h>
#import "JTEventHubArgs.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTEventHub : NSObject

- (NSString *)on:(NSString *)event callback:(void (^)(JTEventHubArgs *args))callback;
- (void)offByIdentifier:(NSString *)identifier;

- (void)emit:(NSString *)event arg0:(nullable id)arg0;
- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1;
- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2;
- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3;
- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4;
- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 arg5:(nullable id)arg5;

@end

NS_ASSUME_NONNULL_END
