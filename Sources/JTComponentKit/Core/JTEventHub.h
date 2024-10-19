//
//  JTEventHub.h
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTEventHub : NSObject

- (void)on:(NSString *)event callback:(void (^)(id arg1, id arg2, id arg3))callback;
- (void)off:(NSString *)event callback:(void (^)(id arg1, id arg2, id arg3))callback;
- (void)emit:(NSString *)event args:(id)arg1, ... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
