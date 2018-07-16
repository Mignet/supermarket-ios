//
//  ZJCalendarManager.h
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/12/1.
//  Copyright © 2017年 Power. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZJCalendarMacros.h"

@class ZJCalendarItemModel;

typedef NS_ENUM(NSInteger, ZJCalendarManagerInvestOrRebackType) {

    Manager_Invest_Type = 0,
    Manager_Reback_Type
};

typedef void (^ZJCalendarUpdateBlock)(ZJCalendarType type, NSInteger index, NSInteger year); // 数据更新通知

typedef void (^ZJCalendarItemBlock) (ZJCalendarItemModel *seleItemModel);

@class ZJCalendarModel;

@interface ZJCalendarManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, assign) ZJCalendarManagerInvestOrRebackType investOrReback;

// 获取签到日期数据
- (NSArray <ZJCalendarModel *> *)getSignCalendarModelArr;

// 获取回款日期数据
- (NSArray <ZJCalendarModel *> *)getRebackCalendarModelArr;

- (ZJCalendarModel *)getSelectedMonthModel;


// 根据选中月份改变数据
- (void)updateSelectedMonthModel:(ZJCalendarModel *)model withIndex:(NSInteger)index;

// 根据选中特定日期改变数据
- (void)updateSelectedItemModel:(ZJCalendarItemModel *)itemModel;


// 选中月份 回调
@property (nonatomic, copy) ZJCalendarUpdateBlock block;

// 选中确定的日期 回调
@property (nonatomic, copy) ZJCalendarItemBlock itemBlock;

// 选中item
@property (nonatomic, strong) ZJCalendarItemModel *selectedItemModel;

- (void)setCurrentDateModel:(ZJCalendarModel *)calendarModel;

- (void)setRebackDateArrWithNil;

@end
