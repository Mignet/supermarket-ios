//
//  ZJRebackMonthItemCell.m
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/12/3.
//  Copyright © 2017年 Power. All rights reserved.
//

#import "ZJRebackMonthItemCell.h"

#import "ZJCalendarManager.h"
#import "ZJCalendarModel.h"

@interface ZJRebackMonthItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

@end

@implementation ZJRebackMonthItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setCalendarModel:(ZJCalendarModel *)calendarModel
{
    _calendarModel = calendarModel;

    self.monthLabel.text = [NSString stringWithFormat:@"%1ld月", calendarModel.month];
    
    if (calendarModel == [[ZJCalendarManager shareInstance] getSelectedMonthModel]) {
        self.monthLabel.textColor = UIColorFromHex(0X4E8CEF);
    } else {
        self.monthLabel.textColor = UIColorFromHex(0X4F5960);
    }
}

@end
