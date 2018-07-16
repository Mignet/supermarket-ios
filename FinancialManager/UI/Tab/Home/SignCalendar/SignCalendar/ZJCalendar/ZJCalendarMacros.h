//
//  ZJCalendarMacros.h
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/12/2.
//  Copyright © 2017年 Power. All rights reserved.
//

#ifndef ZJCalendarMacros_h
#define ZJCalendarMacros_h

#import "NSDate+Extension.h"


typedef NS_ENUM(NSInteger, ZJCalendarType) {
    
    ZJCalendarTypeUnknown,                  // 未定义
    ZJCalendarTypeUp,                       // 上月
    ZJCalendarTypeCurrent,                  // 当前月
    ZJCalendarTypeDown,                     // 下月
    ZJCalendarTypeWeek,                     // 表示星期选项
    ZJCalendarTypeMonth,                    // 表示点击月份
    ZJCalendarTypeItemSlide,                // 表示滑动日期
    ZJCalendarTypeTopSlide,                 // 表示头部滑动
};

// 屏幕宽高
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

// 日历单元格宽高
#define CalendarCell_Width SCREEN_WIDTH
#define CalendarCell_Height (SCREEN_WIDTH / 7.f * 6.f * 0.85)

// 小日历item宽高
#define CalendarItem_Width (SCREEN_WIDTH / 7.f)
#define CalendarItem_Height (SCREEN_WIDTH / 7.f * 0.85)

#endif /* ZJCalendarMacros_h */
