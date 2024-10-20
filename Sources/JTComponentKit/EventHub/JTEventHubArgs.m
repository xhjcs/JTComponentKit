//
//  JTEventHubArgs.m
//  JTComponentKit
//
//  Created by xinghanjie on 2024/10/20.
//

#import "JTEventHubArgs.h"

@implementation JTEventHubArgs

- (instancetype)initWithArgs:(NSArray *)args {
    if (self = [super init]) {
        [args enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self setValue:obj forKey:[@"arg" stringByAppendingString:@(idx).stringValue]];
            if (idx >= 5) {
                *stop = YES;
            }
        }];
    }
    return self;
}

@end
