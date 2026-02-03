//
//  JTEventHubSubscription.m
//  JTComponentKit
//
//  Created by xinghanjie on 2026/2/3.
//

#import "JTEventHubSubscription.h"

@interface JTEventHubSubscription ()

@property (nonatomic, copy) void (^ handler)(void);

@end

@implementation JTEventHubSubscription

+ (instancetype)subscriptionWithHandler:(void (^)(void))handler {
    return [[self alloc] initWithHandler:handler];
}

- (instancetype)initWithHandler:(void (^)(void))handler {
    self = [super init];

    if (self) {
        _handler = [handler copy];
    }

    return self;
}

- (void)remove {
    if (self.handler) {
        self.handler();
        self.handler = nil;
    }
}

@end
