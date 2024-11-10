//
//  JTComponentDefines.h
//  JTComponentKit
//
//  Created by xinghanjie on 2024/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const JTComponentElementKindSectionBackground;

typedef NS_ENUM(NSInteger, JTComponentHeaderPinningBehavior) {
    JTComponentHeaderPinningBehaviorNone = 0,   // 不吸顶
    JTComponentHeaderPinningBehaviorPin,        // 吸顶直到下一个吸顶 header
    JTComponentHeaderPinningBehaviorAlwaysPin,  // 一直吸顶
};

NS_ASSUME_NONNULL_END
