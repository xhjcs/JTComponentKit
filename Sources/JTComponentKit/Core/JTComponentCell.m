//
//  JTComponentCell.m
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import "JTComponentCell.h"

@implementation JTComponentCell

- (void)setRenderView:(UIView *)renderView {
    [_renderView removeFromSuperview];
    _renderView = renderView;
    [self.contentView addSubview:renderView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.renderView.frame = self.bounds;
}

@end
