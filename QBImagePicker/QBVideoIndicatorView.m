//
//  QBVideoIndicatorView.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/04.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBVideoIndicatorView.h"
#import "QBVideoIconView.h"
#import "QBSlomoIconView.h"

#import "Masonry.h"

@implementation QBVideoIndicatorView

- (instancetype)init {
    
    if (self = [super init]) {
        // Add gradient layer
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        gradientLayer.colors = @[
                                 (__bridge id)[[UIColor clearColor] CGColor],
                                 (__bridge id)[[UIColor blackColor] CGColor]
                                 ];
        
        [self.layer insertSublayer:gradientLayer atIndex:0];
        
        _videoIcon = [[QBVideoIconView alloc] init];
        [self addSubview:_videoIcon];
        [_videoIcon mas_makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(5);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(8);
        }];
        
        _slomoIcon = [[QBSlomoIconView alloc] init];
        [self addSubview:_slomoIcon];
        [_slomoIcon mas_makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
            make.top.mas_equalTo(_videoIcon).offset(-3);
            make.leading.mas_equalTo(_videoIcon);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
            make.centerY.mas_equalTo(0);
            make.leading.mas_equalTo(_videoIcon.mas_trailing).offset(4);
            make.trailing.mas_equalTo(-5);
        }];
        
    }
    
    return self;
}

@end
