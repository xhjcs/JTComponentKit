//
//  JTComponentReusableView.m
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import "JTComponentReusableView.h"

@implementation JTComponentReusableView

- (void)setRenderView:(UIView *)renderView {
    [_renderView removeFromSuperview];
    _renderView = renderView;
    [self addSubview:renderView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.renderView.frame = self.bounds;
}

@end
