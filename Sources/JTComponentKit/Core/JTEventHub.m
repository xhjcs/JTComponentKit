//
//  JTEventHub.m
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/19.
//

#import "JTEventHub.h"

@implementation JTEventHub {
    NSMutableDictionary<NSString *, NSMutableArray<void (^)(id, id, id)> *> *_eventCallbacks;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _eventCallbacks = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)on:(NSString *)event callback:(void (^)(id arg1, id arg2, id arg3))callback {
    if (!event || !callback) {
        [NSException raise:@"BusinessError" format:@"Parameter error. Event or callback cannot be nil."];
    }

    NSMutableArray *callbacks = _eventCallbacks[event];

    if (!callbacks) {
        callbacks = [NSMutableArray array];
        _eventCallbacks[event] = callbacks;
    }

    [callbacks addObject:callback];
}

- (void)off:(NSString *)event callback:(void (^)(id arg1, id arg2, id arg3))callback {
    if (!event) {
        [NSException raise:@"BusinessError" format:@"Parameter error. Event cannot be nil."];
    }

    NSMutableArray *callbacks = _eventCallbacks[event];

    if (callbacks && callback) {
        [callbacks removeObject:callback];
    }
}

- (void)emit:(NSString *)event args:(id)arg1, ... {
    if (!event) {
        [NSException raise:@"BusinessError" format:@"Parameter error. Event cannot be nil."];
    }

    NSArray *callbacks = _eventCallbacks[event];

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
