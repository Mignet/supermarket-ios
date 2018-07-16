//
//  ZJSignCalendarCell.h
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/11/30.
//  Copyright © 2017年 Power. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZJCalendarModel;

typedef NS_ENUM(NSInteger, CalendarCellType) {

    Sign_Calendar_Cell = 0,
    Reback_Calendar_Cell
};

@interface ZJSignCalendarCell : UICollectionViewCell

@property (nonatomic, strong) ZJCalendarModel *calendarModel;

@property (nonatomic, assign) CalendarCellType cellType;

@property (nonatomic, strong) NSMutableArray *signArr;

@property (nonatomic, strong) NSMutableArray *investStatisticsArr;

@end
