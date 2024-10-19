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
    renderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:renderView];
    [NSLayoutConstraint activateConstraints:@[
         [renderView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
         [renderView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
         [renderView.topAnchor constraintEqualToAnchor:self.topAnchor],
         [renderView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

@end
