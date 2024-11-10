//
//  JTSpacingComponent.m
//  JTComponentKit
//
//  Created by xinghanjie on 2024/11/10.
//

#import "JTSpacingComponent.h"

@interface JTSpacingComponent ()

@property (nonatomic) CGFloat spacing;

@end

@implementation JTSpacingComponent

+ (instancetype)componentWithSpacing:(CGFloat)spacing {
    return [[self alloc] initWithSpacing:spacing];
}

- (instancetype)initWithSpacing:(CGFloat)spacing {
    if (self = [super init]) {
        _spacing = spacing;
    }

    return self;
}

- (UIEdgeInsets)inset {
    return UIEdgeInsetsMake(self.spacing, self.spacing, 0.0, 0.0);
}

@end
