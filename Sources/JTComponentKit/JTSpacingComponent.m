//
//  JTSpacingComponent.m
//  JTComponentKit
//
//  Created by xinghanjie on 2024/11/10.
//

#import "JTSpacingComponent.h"

@implementation JTSpacingComponent

+ (instancetype)componentWithSpacing:(CGFloat)spacing {
    return [[self alloc] initWithSpacingInsets:UIEdgeInsetsMake(spacing, spacing, 0.0, 0.0)];
}

+ (instancetype)componentWithSpacingInsets:(UIEdgeInsets)spacingInsets {
    return [[self alloc] initWithSpacingInsets:spacingInsets];
}

+ (instancetype)componentWithSpacing:(CGFloat)spacing backgroundColor:(UIColor *)backgroundColor {
    JTSpacingComponent *component = [[self alloc] initWithSpacingInsets:UIEdgeInsetsMake(spacing, spacing, 0.0, 0.0)];
    component.backgroundColor = backgroundColor;
    return component;
}

- (instancetype)init {
    return [self initWithSpacingInsets:UIEdgeInsetsZero];
}

- (instancetype)initWithSpacingInsets:(UIEdgeInsets)spacingInsets {
    if (self = [super init]) {
        _spacingInsets = spacingInsets;
        _backgroundInsets = UIEdgeInsetsZero;
    }

    return self;
}

#pragma mark - Section

- (UIEdgeInsets)insets {
    return self.spacingInsets;
}

#pragma mark - Background

- (UIEdgeInsets)insetsForBackgroundView {
    return self.backgroundInsets;
}

- (NSInteger)zIndexForBackgroundView {
    return self.backgroundColor ? -1 : 0;
}

- (__kindof UIView *)backgroundView {
    if (!self.backgroundColor) {
        return [super backgroundView];
    }

    UIView *backgroundView = [self dequeueReusableBackgroundViewOfClass:[UIView class]];
    backgroundView.backgroundColor = self.backgroundColor;
    backgroundView.layer.cornerRadius = self.cornerRadius;
    backgroundView.layer.masksToBounds = self.cornerRadius > 0.0;
    return backgroundView;
}

@end
