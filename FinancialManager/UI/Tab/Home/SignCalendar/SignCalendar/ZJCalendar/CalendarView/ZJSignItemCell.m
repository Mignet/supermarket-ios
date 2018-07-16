//
//  ZJSignItemCell.m
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/11/30.
//  Copyright © 2017年 Power. All rights reserved.
//

#import "ZJSignItemCell.h"
#import "ZJCalendarItemModel.h"
#import "ZJCalendarMacros.h"

@implementation ZJSignItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.signImg.hidden = YES;
}

/////////////////////////
#pragma mark - setter / getter
/////////////////////////

- (void)setItemModel:(ZJCalendarItemModel *)itemModel
{
    _itemModel = itemModel;

    switch (itemModel.type) {
        case ZJCalendarTypeUp:
        case ZJCalendarTypeDown:
        {
            self.dayLabel.textColor = UIColorFromHex(0XB2B2B2);
        }
            break;
            
        case ZJCalendarTypeCurrent:
        {
            if (itemModel.isNowDay) {
                self.dayLabel.textColor = UIColorFromHex(0X4E8CEF);
            } else {
                self.dayLabel.textColor = UIColorFromHex(0X4F5960);
            }
        }
            
        default:
            break;
    }
    
    self.dayLabel.text = [NSString stringWithFormat:@"%ld", itemModel.date.day];
}


@end
