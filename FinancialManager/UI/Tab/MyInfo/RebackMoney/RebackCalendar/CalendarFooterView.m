//
//  CalendarFooterView.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/11.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "CalendarFooterView.h"


@implementation CalendarFooterView

+ (instancetype)calendarFooterView;
{
    CalendarFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CalendarFooterView class]) owner:nil options:nil] firstObject];
    
    return footerView;
}

@end
