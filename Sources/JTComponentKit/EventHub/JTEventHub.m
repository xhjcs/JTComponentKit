//
//  JTEventHub.m
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/19.
//

#import "JTEventHub.h"
#import "JTEventHubArgs_Private.h"

@interface JTEventHub ()

@property (nonatomic) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, void (^)(JTEventHubArgs *args)> *> *eventCallbacks;

@end

@implementation JTEventHub

- (instancetype)init {
    self = [super init];

    if (self) {
        _eventCallbacks = [NSMutableDictionary dictionary];
    }

    return self;
}

- (NSString *)on:(NSString *)event callback:(void (^)(JTEventHubArgs *args))callback {
    NSCParameterAssert(event);
    NSCParameterAssert(callback);

    if (!event) {
        return nil;
    }

    NSMutableDictionary<NSString *, void (^)(JTEventHubArgs *args)> *callbacks = self.eventCallbacks[event];

    if (!callbacks) {
        callbacks = [NSMutableDictionary new];
        _eventCallbacks[event] = callbacks;
    }

    NSString *identifier = [[NSUUID UUID] UUIDString];
    callbacks[identifier] = callback;
    return identifier;
}

- (void)off:(NSString *)event identifier:(NSString *)identifier {
    NSCParameterAssert(event);
    NSCParameterAssert(identifier);

    if (!event || !identifier) {
        return;
    }

    NSMutableDictionary<NSString *, void (^)(JTEventHubArgs *args)> *callbacks = self.eventCallbacks[event];
    callbacks[identifier] = nil;

    if (callbacks.count <= 0) {
        self.eventCallbacks[event] = nil;
    }
}

- (void)emit:(NSString *)event args:(id)arg1, ... {
    NSCParameterAssert(event);

    NSArray *callbacks = _eventCallbacks[event].allValues;

    NSMutableArray *argsArray = [NSMutableArray array];

    va_list args;
    va_start(args, arg1);

    for (id arg = arg1; arg != nil; arg = va_arg(args, id)) {
        [argsArray addObject:arg];
    }

    va_end(args);

    for (void (^callback)(JTEventHubArgs *args) in callbacks) {
        callback([[JTEventHubArgs alloc] initWithArgs:argsArray]);
    }
}

@end
