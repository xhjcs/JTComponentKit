//
//  JTComponentDefines.h
//  Pods
//
//  Created by xinghanjie on 2024/11/5.
//

#ifndef JTComponentDefines_h
#define JTComponentDefines_h

typedef NS_ENUM(NSInteger, JTComponentHeaderPinningBehavior) {
    JTComponentHeaderPinningBehaviorNone = 0,   // 不吸顶
    JTComponentHeaderPinningBehaviorPin,        // 吸顶
    JTComponentHeaderPinningBehaviorPinUntilNextPinHeader, // 吸顶直到下一个吸顶 header
    JTComponentHeaderPinningBehaviorAlwaysPin,  // 一直吸顶
};

#endif /* JTComponentDefines_h */
