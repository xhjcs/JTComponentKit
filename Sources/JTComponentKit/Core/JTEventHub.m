//
//  JTEventHub.m
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/19.
//

#import "JTEventHub.h"

@interface JTEventHub ()

@property (nonatomic) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, void (^)(id, id, id)> *> *eventCallbacks;

@end

@implementation JTEventHub

- (instancetype)init {
    self = [super init];

    if (self) {
        _eventCallbacks = [NSMutableDictionary dictionary];
    }

    return self;
}

- (NSString *)on:(NSString *)event callback:(void (^)(id arg1, id arg2, id arg3))callback {
    NSCParameterAssert(event);
    NSCParameterAssert(callback);

    NSMutableDictionary<NSString *, void (^)(id, id, id)> *callbacks = self.eventCallbacks[event];

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

    NSMutableDictionary<NSString *, void (^)(id, id, id)> *callbacks = self.eventCallbacks[event];
    callbacks[identifier] = nil;

    if (callbacks.count <= 0) {
        self.eventCallbacks[event] = nil;
    }
}

- (void)emit:(NSString *)event args:(id)arg1, ... {
    NSCParameterAssert(event);

    NSArray *callbacks = _eventCallbacks[event].allValues;

    for (void (^callback)(id, id, id) in callbacks) {
        va_list args;
        va_start(args, arg1);

        id arg2 = va_arg(args, id);
        id arg3 = va_arg(args, id);

        callback(arg1, arg2, arg3);

        va_end(args);
    }
}

@end
