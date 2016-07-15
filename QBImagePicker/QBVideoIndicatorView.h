//
//  QBVideoIndicatorView.h
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/04.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QBVideoIconView.h"
#import "QBSlomoIconView.h"

@interface QBVideoIndicatorView : UIView

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) QBVideoIconView *videoIcon;
@property (nonatomic, strong) QBSlomoIconView *slomoIcon;


@end
