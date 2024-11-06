//
//  JTBComponent.h
//  Example
//
//  Created by xinghanjie on 2024/10/21.
//

#import <JTComponentKit/JTComponentKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTBComponent : JTComponent

@property (nonatomic) JTComponentHeaderPinningBehavior pinningBehavior;
@property (nonatomic, copy) NSString *headerTitle;

@end

NS_ASSUME_NONNULL_END
