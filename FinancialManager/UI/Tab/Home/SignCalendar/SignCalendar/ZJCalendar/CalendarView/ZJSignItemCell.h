//
//  ZJSignItemCell.h
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/11/30.
//  Copyright © 2017年 Power. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJCalendarItemModel;

@interface ZJSignItemCell : UICollectionViewCell

@property (nonatomic, strong) ZJCalendarItemModel *itemModel;

@property (nonatomic, strong) NSMutableArray *signArr;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signImg;


@end
