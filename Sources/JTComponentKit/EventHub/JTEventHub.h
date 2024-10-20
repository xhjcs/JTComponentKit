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
- (void)off:(NSString *)event identifier:(NSString *)identifier;
- (void)emit:(NSString *)event args:(id)arg1, ... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
