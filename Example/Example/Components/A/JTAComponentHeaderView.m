//
//  JTAComponentHeaderView.m
//  Example
//
//  Created by xinghanjie on 2024/10/19.
//

#import "JTAComponentHeaderView.h"

@implementation JTAComponentHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tap];
    }

    return self;
}

- (void)onTap:(UITapGestureRecognizer *)sender {
    if (self.onClickHandler) {
        self.onClickHandler();
    }
}

@end
