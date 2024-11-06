//
//  JTAComponent.h
//  Example
//
//  Created by xinghanjie on 2024/10/15.
//

#import <UIKit/UIKit.h>
#import <JTComponentKit/JTComponentKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JTAComponent : JTComponent

@property (nonatomic) JTComponentHeaderPinningBehavior pinningBehavior;
@property (nonatomic, copy) NSString *headerTitle;

@end

NS_ASSUME_NONNULL_END
