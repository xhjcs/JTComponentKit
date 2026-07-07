//
//  JTSpacingComponent.h
//  JTComponentKit
//
//  Created by xinghanjie on 2024/11/10.
//

#import "JTComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTSpacingComponent : JTComponent

/// Section 内边距，决定模块间的留白大小
@property (nonatomic) UIEdgeInsets spacingInsets;

/// Section 背景色，nil 时不展示背景
@property (nonatomic, nullable) UIColor *backgroundColor;

/// 背景圆角，默认 0
@property (nonatomic) CGFloat cornerRadius;

/// 背景相对 Section 区域的缩进
@property (nonatomic) UIEdgeInsets backgroundInsets;

- (instancetype)initWithSpacingInsets:(UIEdgeInsets)spacingInsets NS_DESIGNATED_INITIALIZER;

+ (instancetype)componentWithSpacing:(CGFloat)spacing;
/// 便捷构造：spacing 仅作用于 top 与 left，bottom/right 为 0。
+ (instancetype)componentWithSpacingInsets:(UIEdgeInsets)spacingInsets;
+ (instancetype)componentWithSpacing:(CGFloat)spacing backgroundColor:(nullable UIColor *)backgroundColor;

@end

NS_ASSUME_NONNULL_END
