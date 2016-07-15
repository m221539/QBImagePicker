//
//  QBAssetCell.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetCell.h"
#import "QBVideoIndicatorView.h"
#import "QBCheckmarkView.h"

#import "Masonry.h"

@implementation QBAssetCell {
    @private
    QBCheckmarkView *_checkMarkView;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Show/hide overlay view
    _checkMarkView.hidden = !(selected && self.showsOverlayViewWhenSelected);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
            make.edges.mas_equalTo(superview);
        }];
        
        _videoIndicatorView = [[QBVideoIndicatorView alloc] init];
        [self.contentView addSubview:_videoIndicatorView];
        [_videoIndicatorView mas_makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
            make.height.mas_equalTo(20);
            make.leading.mas_equalTo(0);
            make.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        _checkMarkView = [[QBCheckmarkView alloc] init];
        _checkMarkView.hidden = YES;
        [self.contentView addSubview:_checkMarkView];
        [_checkMarkView mas_makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
            make.size.mas_equalTo(CGSizeMake(24, 24));
            make.trailing.mas_equalTo(-3);
            make.bottom.mas_equalTo(-3);
        }];
    }
    return self;
}

@end
