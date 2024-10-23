//
//  JTAComponentItemView.m
//  Example
//
//  Created by xinghanjie on 2024/10/19.
//

#import "JTAComponentItemView.h"

@implementation JTAComponentItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor greenColor];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
    }
    return self;
}

- (void)onTap {
    if (self.onTopHander) {
        self.onTopHander();
    }
}

@end
