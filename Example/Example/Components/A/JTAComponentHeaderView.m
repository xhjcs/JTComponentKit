//
//  JTAComponentHeaderView.m
//  Example
//
//  Created by xinghanjie on 2024/10/19.
//

#import "JTAComponentHeaderView.h"
#import <Masonry/Masonry.h>

@interface JTAComponentHeaderView ()

@end

@implementation JTAComponentHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tap];
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor blackColor];
//        _titleLabel.text = [NSString stringWithFormat:@"section: %@ - %@", [self valueForKey:@"section"], self.headerTitle];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }

    return self;
}

- (void)onTap:(UITapGestureRecognizer *)sender {
    if (self.onClickHandler) {
        self.onClickHandler();
    }
}

@end
