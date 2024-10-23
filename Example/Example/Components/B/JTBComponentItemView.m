//
//  JTBComponentItemView.m
//  Example
//
//  Created by xinghanjie on 2024/10/21.
//

#import "JTBComponentItemView.h"
#import <Masonry/Masonry.h>

@implementation JTBComponentItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [UILabel new];
        [self addSubview:label];
        label.textColor = [UIColor grayColor];
        label.text = @"Hello Wrold";
        label.backgroundColor = [UIColor yellowColor];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.right.greaterThanOrEqualTo(self).offset(-10);
            make.top.equalTo(self).offset(2);
            make.bottom.greaterThanOrEqualTo(self).offset(-2);
        }];
        _titleLabel = label;
    }
    return self;
}

@end
