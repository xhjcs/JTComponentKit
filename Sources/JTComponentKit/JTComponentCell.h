//
//  JTComponentCell.h
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import <UIKit/UIKit.h>

@class JTComponent;

NS_ASSUME_NONNULL_BEGIN

@interface JTComponentCell : UICollectionViewCell

@property (nonatomic) UIView *renderView;
@property (nonatomic, weak, nullable) JTComponent *component;
@property (nonatomic) NSInteger displayIndex;

@end

NS_ASSUME_NONNULL_END
