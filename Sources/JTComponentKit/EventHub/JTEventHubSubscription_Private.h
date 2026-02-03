//
//  JTEventHubSubscription_Private.h
//  Pods
//
//  Created by xinghanjie on 2026/2/3.
//

#ifndef JTEventHubSubscription_Private_h
#define JTEventHubSubscription_Private_h

#import "JTEventHubSubscription.h"

@interface JTEventHubSubscription ()

+ (instancetype)subscriptionWithHandler:(void (^)(void))handler;

@end


#endif /* JTEventHubSubscription_Private_h */
