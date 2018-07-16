//
//  ZJRebackItemCell.m
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/12/3.
//  Copyright © 2017年 Power. All rights reserved.
//

#import "ZJRebackItemCell.h"
#import "ZJCalendarItemModel.h"
#import "ZJCalendarManager.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation ZJRebackItemCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 圆形
    
    self.signView.layer.cornerRadius = (SCREEN_WIDTH / 7.f - 20.f) / 2.f;
    self.signView.layer.masksToBounds = YES;
    
    self.rebackNumLabel.layer.cornerRadius = 8.f;
    self.rebackNumLabel.layer.masksToBounds = YES;
    
    self.signView.hidden = YES;
    self.rebackNumLabel.hidden = YES;
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
            self.dayLabel.textColor = UIColorFromHex(0XE3E3E3);
            self.signView.hidden = YES;
        }
            break;
            
        case ZJCalendarTypeCurrent:
        {
            if (itemModel.isNowDay) {
                self.dayLabel.textColor = UIColorFromHex(0X4E8CEF);
                self.signImgView.hidden = NO;
                self.signView.hidden = NO;
            } else {
                self.dayLabel.textColor = UIColorFromHex(0XB2B2B2);
                self.signView.hidden = YES;
            }
            
            
            if (itemModel.isSelected) {
                
                self.signView.hidden = NO;
                self.dayLabel.textColor = [UIColor whiteColor];
                self.dayLabel.font = [UIFont systemFontOfSize:15.f];
                
                // 添加简易动画
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                animation.duration = 0.15;
                animation.repeatCount = 1;
                animation.autoreverses = YES;
                animation.fromValue = [NSNumber numberWithFloat:1.0];
                animation.toValue = [NSNumber numberWithFloat:1.1];
                [self.signView.layer addAnimation:animation forKey:@"scale-layer"];
            
            } else {
                
                self.signView.hidden = YES;
            }
        }
            
        default:
            break;
    }
    
    
    self.dayLabel.text = [NSString stringWithFormat:@"%ld", itemModel.date.day];
}

//- (UIColor *)stringTOColor:(NSString *)str
//{
//    if (!str || [str isEqualToString:@""]) {
//        return nil;
//    }
//    unsigned red,green,blue;
//    NSRange range;
//    range.length = 2;
//    range.location = 1;
//    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
//    range.location = 3;
//    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
//    range.location = 5;
//    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
//    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
//    return color;
//}

- (IBAction)btnClick {
    
    if (self.itemModel.type == ZJCalendarTypeCurrent) {
        [[ZJCalendarManager shareInstance] updateSelectedItemModel:self.itemModel];
    }
}

@end
