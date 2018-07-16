//
//  ZJRebackItemCell.h
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/12/3.
//  Copyright © 2017年 Power. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJCalendarItemModel;

@interface ZJRebackItemCell : UICollectionViewCell

@property (nonatomic, strong) ZJCalendarItemModel *itemModel;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet UIImageView *signImgView;

@property (weak, nonatomic) IBOutlet UILabel *rebackNumLabel;


@end
