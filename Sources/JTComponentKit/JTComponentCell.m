//
//  JTComponentCell.m
//  Example
//
//  Created by xinghanjie on 2024/10/16.
//

#import "JTComponentCell.h"

@interface JTComponentCell ()

@property (nonatomic, copy) NSArray<NSLayoutConstraint *> *renderViewConstraints;

@end

@implementation JTComponentCell

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
    [self.contentView addSubview:renderView];
    self.renderViewConstraints = @[
        [renderView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [renderView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [renderView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [renderView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
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
