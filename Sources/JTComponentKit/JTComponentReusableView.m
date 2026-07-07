//
//  JTComponentReusableView.m
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import "JTComponentReusableView.h"

@interface JTComponentReusableView ()

@property (nonatomic, copy) NSArray<NSLayoutConstraint *> *renderViewConstraints;

@end

@implementation JTComponentReusableView

- (void)setRenderView:(UIView *)renderView {
    if (_renderView == renderView) {
        return;
    }

    [NSLayoutConstraint deactivateConstraints:self.renderViewConstraints];
    self.renderViewConstraints = nil;
    [_renderView removeFromSuperview];
    _renderView = renderView;

    if (!renderView) {
        return;
    }

    renderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:renderView];
    self.renderViewConstraints = @[
        [renderView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [renderView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [renderView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [renderView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ];
    [NSLayoutConstraint activateConstraints:self.renderViewConstraints];
}

- (void)prepareForReuse {
    [super prepareForReuse];

    if ([_renderView respondsToSelector:@selector(prepareForReuse)]) {
        [_renderView performSelector:@selector(prepareForReuse)];
    }
}

@end
