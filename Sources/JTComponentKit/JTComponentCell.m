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
    renderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:renderView];
    [NSLayoutConstraint activateConstraints:@[
         [renderView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
         [renderView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
         [renderView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
         [renderView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
    ]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    if ([_renderView respondsToSelector:@selector(prepareForReuse)]) {
        [_renderView performSelector:@selector(prepareForReuse)];
    }
}

@end
