//
//  JTEventHub.m
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/19.
//

#import "JTEventHub.h"
#import "JTEventHubArgs_Private.h"
#import "JTEventHubSubscription_Private.h"

@interface JTEventHub ()

@property (nonatomic) NSMutableDictionary<NSString *, NSMutableArray<void (^)(JTEventHubArgs *args)> *> *eventCallbacks;

@end

@implementation JTEventHub

- (instancetype)init {
    self = [super init];

    if (self) {
        _eventCallbacks = [NSMutableDictionary dictionary];
    }

    return self;
}

- (JTEventHubSubscription *)on:(NSString *)event callback:(void (^)(JTEventHubArgs *args))callback {
    NSCParameterAssert(event);
    NSCParameterAssert(callback);

    if (!event || !callback) {
        return nil;
    }

    NSMutableArray<void (^)(JTEventHubArgs *args)> *callbacks = self.eventCallbacks[event];

    if (!callbacks) {
        callbacks = [NSMutableArray new];
        self.eventCallbacks[event] = callbacks;
    }

    [callbacks addObject:callback];

    return [JTEventHubSubscription subscriptionWithHandler:^{
        [callbacks removeObject:callback];
    }];
}

- (void)emit:(NSString *)event arg0:(nullable id)arg0 {
    [self emit:event arg0:arg0 arg1:nil arg2:nil arg3:nil arg4:nil arg5:nil];
}

- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 {
    [self emit:event arg0:arg0 arg1:arg1 arg2:nil arg3:nil arg4:nil arg5:nil];
}

- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 {
    [self emit:event arg0:arg0 arg1:arg1 arg2:arg2 arg3:nil arg4:nil arg5:nil];
}

- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 {
    [self emit:event arg0:arg0 arg1:arg1 arg2:arg2 arg3:arg3 arg4:nil arg5:nil];
}

- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 {
    [self emit:event arg0:arg0 arg1:arg1 arg2:arg2 arg3:arg3 arg4:arg4 arg5:nil];
}

- (void)emit:(NSString *)event arg0:(nullable id)arg0 arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 arg5:(nullable id)arg5 {
    NSCParameterAssert(event);
    JTEventHubArgs *args = [JTEventHubArgs new];
    args.arg0 = arg0;
    args.arg1 = arg1;
    args.arg2 = arg2;
    args.arg3 = arg3;
    args.arg4 = arg4;
    args.arg5 = arg5;
    NSArray *callbacks = self.eventCallbacks[event];

    for (void (^callback)(JTEventHubArgs *args) in callbacks) {
        callback(args);
    }
}

@end
