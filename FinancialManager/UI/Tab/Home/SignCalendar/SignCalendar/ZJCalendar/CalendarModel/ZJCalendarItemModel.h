//
//  ZJCalendarItemModel.h
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/12/1.
//  Copyright © 2017年 Power. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJCalendarMacros.h"

@interface ZJCalendarItemModel : NSObject

@property (nonatomic, assign) BOOL isNowDay;            // 是否当天
@property (nonatomic, assign) BOOL isSelected;          // 是否选中

@property (nonatomic, assign) NSInteger index;          // 索引
@property (nonatomic, assign) ZJCalendarType type;      // 类型

// 日期属性
@property (nonatomic, strong) NSDate *date;             // 当前日期

// 星期属性
@property (nonatomic, copy) NSString *weekday;          // 星期

// 月份属性
@property (nonatomic, copy) NSString *month;            // 月份

@property (nonatomic, copy) NSString *year;             // 年份

@end
