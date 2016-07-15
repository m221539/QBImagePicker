//
//  QBAlbumCell.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAlbumCell.h"
#import "Masonry.h"

@implementation QBAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
                
        UIView *imageContainer = [[UIView alloc] init];
        [self.contentView addSubview:imageContainer];
        [imageContainer mas_makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
            make.leading.mas_equalTo(8);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(88);
            make.height.mas_equalTo(72);
        }];
        
        _imageView1 = [[UIImageView alloc] init];
        _imageView1.contentMode = UIViewContentModeScaleAspectFill;
        _imageView1.clipsToBounds = YES;
        [imageContainer addSubview:_imageView1];
        [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
            make.size.mas_equalTo(CGSizeMake(68, 68));
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        _imageView2 = [[UIImageView alloc] init];
        _imageView2.contentMode = UIViewContentModeScaleAspectFill;
        _imageView2.clipsToBounds = YES;
        [imageContainer addSubview:_imageView2];
        [_imageView2 mas_makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(2);
            make.size.mas_equalTo(CGSizeMake(64, 64));
        }];
        
        _imageView3 = [[UIImageView alloc] init];
        _imageView3.contentMode = UIViewContentModeScaleAspectFill;
        _imageView3.clipsToBounds = YES;
        [imageContainer addSubview:_imageView3];
        [_imageView3 mas_makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        [imageContainer bringSubviewToFront:_imageView2];
        [imageContainer bringSubviewToFront:_imageView1];

        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.numberOfLines = 1;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
            make.top.mas_equalTo(14);
            make.leading.mas_equalTo(imageContainer.mas_trailing).offset(18);
            make.trailing.mas_equalTo(0);
            make.height.mas_equalTo(21);
        }];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.numberOfLines = 1;
        [self addSubview:_countLabel];
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make, UIView *superview) {
            make.leading.mas_equalTo(_titleLabel);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(3);
            make.trailing.mas_equalTo(_titleLabel);
            make.height.mas_equalTo(15);
        }];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    
    self.imageView1.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView1.layer.borderWidth = borderWidth;
    
    self.imageView2.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView2.layer.borderWidth = borderWidth;
    
    self.imageView3.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView3.layer.borderWidth = borderWidth;
}

@end
