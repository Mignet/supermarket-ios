//
//  ZJCalendarManager.m
//  4_5_1日历
//
//  Created by 张吉晴 on 2017/12/1.
//  Copyright © 2017年 Power. All rights reserved.
//

#import "ZJCalendarManager.h"
#import "ZJCalendarModel.h"
#import "ZJCalendarItemModel.h"
#import "NSDate+Extension.h"
#import "ZJCalendarItemModel.h"

typedef NS_ENUM(NSInteger, ZJCalendarManagerIntervalMonthNumType){

    Sign_Month_Num = 0,
    Invest_Month_Num,
    Reback_Month_Num
};


@interface ZJCalendarManager ()

@property (nonatomic, strong) NSDate *signStartDate;

@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) NSDate *rebackStartDate;
//@property (nonatomic, strong) NSDate *rebackEndDate;

@property (nonatomic, assign) NSInteger intervalMonthNum;

/*** 日历数据源 **/
@property (nonatomic, strong) NSArray <ZJCalendarModel *> *rebackDataArr;

@property (nonatomic, strong) NSArray <ZJCalendarModel *> *signDataArr;

/*** 当前选中的月份数据 **/
@property (nonatomic, strong) ZJCalendarModel *selectedMonthModel;

@end

@implementation ZJCalendarManager

+ (instancetype)shareInstance
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Setter/Getter

- (NSDate *)signStartDate
{
    if (!_signStartDate) {
        
        // 时间字符串
        NSString *string = @"2017-12-01 00:00:00";
        
        // 日期格式化类
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        // 设置日期格式 为了转换成功
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        _signStartDate = [format dateFromString:string];
    }
    
    return _signStartDate;
}

- (NSDate *)rebackStartDate
{
    if (!_rebackStartDate) {
        
        // 时间字符串
        NSString *string = @"2016-09-01 00:00:00";
        
        // 日期格式化类
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        // 设置日期格式 为了转换成功
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        _rebackStartDate = [format dateFromString:string];
    }
    
    return _rebackStartDate;
}

- (NSDate *)currentDate
{
    // 获得时间对象
    NSDate *date = [NSDate date];
//    // 获得系统的时区
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    // 当前时间与系统格林尼治时间的差
//    NSTimeInterval time = [zone secondsFromGMTForDate:date];
//    // 当前系统准确的时间
    _currentDate = date;
    
    return _currentDate;
}

// 获取日期数据
- (NSArray<ZJCalendarModel *> *)getSignCalendarModelArr
{
    return self.signDataArr;
}

// 获取回款日期数据
- (NSArray <ZJCalendarModel *> *)getRebackCalendarModelArr
{
    return self.rebackDataArr;
}

- (NSArray <ZJCalendarModel *> *)signDataArr
{
    
    NSInteger intervalMonthNum = [self intervalMonthNum:Sign_Month_Num];
    
    if (!_signDataArr) {
        
        NSMutableArray *mDataArray = [NSMutableArray arrayWithCapacity:0];
        
        for (NSInteger i = 0; i < intervalMonthNum; i++) {
            
            
            ZJCalendarModel *calendarModel = [[ZJCalendarModel alloc] init];
            
        
            
            NSMutableArray *mItemArray = [NSMutableArray arrayWithCapacity:0];
            
            // 当月
            NSDate *curDate = [self.signStartDate dateAfterMonth:i];
            
            // 当月天数
            NSInteger curMonthSize = [curDate daysInMonth];
            
            // 当月第一天
            NSDate *beginDate = [curDate begindayOfMonth];
            // 当月第一天对应的星期
            NSInteger weekIndex = beginDate.weekday;
            
            // 当月第一天如果是周日，默认从第二排开始
            NSInteger upSize = weekIndex == 1 ? 7 : weekIndex - 1;
            
            // 当月第一天日期前移 upSize 天，得到当月记录的第一天（从上月开始记录）
            NSDate *startDate = [beginDate dateAfterDay:-upSize];
            
            // 记录游标
            NSInteger cursor = 0;
            
            // 记录上月日期部分
            for (NSInteger j = 0; j < upSize; j++, cursor++) {
                
                ZJCalendarItemModel *item = [[ZJCalendarItemModel alloc] init];
                
                item.index = i;                 // 设置索引
                item.date = [startDate dateAfterDay:cursor];
                item.type = ZJCalendarTypeUp;
                
                [mItemArray addObject:item];
            }
            
            // 记录当月日期部分
            for (NSInteger jj = 0; jj < curMonthSize; jj++, cursor++) {
                
                ZJCalendarItemModel *item = [[ZJCalendarItemModel alloc] init];
                
                item.index = i;                 // 设置索引
                item.date = [startDate dateAfterDay:cursor];
                item.type = ZJCalendarTypeCurrent;
                

                if ([item.date isSameDay:self.currentDate]) { // 判断是否是今天
                
                    item.isNowDay = YES;
                    calendarModel.isShow = YES;
                    item.isNowDay = YES;
                    item.isSelected = YES;
                }
                
                [mItemArray addObject:item];
            }
            
            // 记录下月日期部分
            NSInteger downSize = 42 - upSize - curMonthSize;      // 剩下天数
            for (NSInteger jjj = 0; jjj < downSize; jjj++, cursor++) {
                
                ZJCalendarItemModel *item = [[ZJCalendarItemModel alloc] init];
                
                item.index = i;                 // 设置索引
                item.date = [startDate dateAfterDay:cursor];
                item.type = ZJCalendarTypeDown;
                
                [mItemArray addObject:item];
            }
            
            calendarModel.year = [curDate year];
            calendarModel.month = [curDate month];
        
            calendarModel.dataArray = mItemArray.copy;                // 设置当月日期
            
            [mDataArray addObject:calendarModel];
        }
        
        _signDataArr = mDataArray.copy;
    }

    return _signDataArr;
}

- (NSArray <ZJCalendarModel *> *)rebackDataArr
{
    NSInteger intervalMonthNum = 0;
    
    if ([ZJCalendarManager shareInstance].investOrReback == Manager_Invest_Type) {
        intervalMonthNum = [self intervalMonthNum:Invest_Month_Num];
    } else if ([ZJCalendarManager shareInstance].investOrReback == Manager_Reback_Type) {
        intervalMonthNum = [self intervalMonthNum:Reback_Month_Num];
    }
    
    if (!_rebackDataArr) {
        
        NSMutableArray *mDataArray = [NSMutableArray arrayWithCapacity:0];
        
        for (NSInteger i = 0; i < intervalMonthNum; i++) {
            
            
            ZJCalendarModel *calendarModel = [[ZJCalendarModel alloc] init];
            
            calendarModel.index = i;
            
            NSMutableArray *mItemArray = [NSMutableArray arrayWithCapacity:0];
            
            // 当月
            NSDate *curDate = [self.rebackStartDate dateAfterMonth:i];
            
            // 当月天数
            NSInteger curMonthSize = [curDate daysInMonth];
            
            // 当月第一天
            NSDate *beginDate = [curDate begindayOfMonth];
            // 当月第一天对应的星期
            NSInteger weekIndex = beginDate.weekday;
            
            // 当月第一天如果是周日，默认从第二排开始
            NSInteger upSize = weekIndex == 1 ? 7 : weekIndex - 1;
            
            // 当月第一天日期前移 upSize 天，得到当月记录的第一天（从上月开始记录）
            NSDate *startDate = [beginDate dateAfterDay:-upSize];
            
            // 记录游标
            NSInteger cursor = 0;
            
            // 记录上月日期部分
            for (NSInteger j = 0; j < upSize; j++, cursor++) {
                
                ZJCalendarItemModel *item = [[ZJCalendarItemModel alloc] init];
                
                item.index = i;                 // 设置索引
                item.date = [startDate dateAfterDay:cursor];
                item.type = ZJCalendarTypeUp;
                
                [mItemArray addObject:item];
            }
            
            // 记录当月日期部分
            for (NSInteger jj = 0; jj < curMonthSize; jj++, cursor++) {
                
                ZJCalendarItemModel *item = [[ZJCalendarItemModel alloc] init];
                
                item.index = i;                 // 设置索引
                item.date = [startDate dateAfterDay:cursor];
                item.type = ZJCalendarTypeCurrent;
                
                
                if ([item.date isSameDay:self.currentDate]) { // 判断是否是今天
                    
                    item.isNowDay = YES;
                    calendarModel.isShow = YES;
                    
                    item.isNowDay = YES;
                    item.isSelected = YES;
                    self.selectedItemModel = item;
                    
                    self.selectedMonthModel = calendarModel;
                    
                }
                
                [mItemArray addObject:item];
            }
            
            // 记录下月日期部分
            NSInteger downSize = 42 - upSize - curMonthSize;      // 剩下天数
            for (NSInteger jjj = 0; jjj < downSize; jjj++, cursor++) {
                
                ZJCalendarItemModel *item = [[ZJCalendarItemModel alloc] init];
                
                item.index = i;                 // 设置索引
                item.date = [startDate dateAfterDay:cursor];
                item.type = ZJCalendarTypeDown;
                
                [mItemArray addObject:item];
            }
            
            calendarModel.year = [curDate year];
            calendarModel.month = [curDate month];
            
            calendarModel.dataArray = mItemArray.copy;                // 设置当月日期
            
            [mDataArray addObject:calendarModel];
        }
        
        _rebackDataArr = mDataArray.copy;
    }
    
    return _rebackDataArr;

}

// 间隔月数
- (NSInteger)intervalMonthNum:(ZJCalendarManagerIntervalMonthNumType)intervalMonthNumType
{
    NSInteger intervalMonthNum;
    
    if (intervalMonthNumType == Sign_Month_Num) { // 签到时间间隔月
        
        NSInteger startYear = [self.signStartDate year];
        NSInteger startMonth = [self.signStartDate month];
        NSInteger currentYear = [self.currentDate year];
        NSInteger currentMonth = [self.currentDate month];
        
        if (startYear == currentYear) {
            
            intervalMonthNum = currentMonth - startMonth + 1;
            
        } else { // 年份不等
        
            if (startMonth == currentMonth) { // 月份相等
                
                intervalMonthNum = (currentYear - startYear) * 12 + 1;
                
            } else { // 月份不等
        
                intervalMonthNum = (12 - startMonth + 1) + (currentYear - startYear - 1) * 12 + currentMonth;
            }
        }
        
    }
    
    else if (intervalMonthNumType == Invest_Month_Num)  { // 投资记录时间间隔月
    
        NSInteger startYear = [self.rebackStartDate year];
        NSInteger startMonth = [self.rebackStartDate month];
        NSInteger currentYear = [self.currentDate year];
        NSInteger currentMonth = [self.currentDate month];
        
        if (startYear == currentYear) {
            
            intervalMonthNum = currentMonth - startMonth + 1;
            
        } else { // 年份不等
            
            if (startMonth == currentMonth) { // 月份相等
                
                intervalMonthNum = (currentYear - startYear) * 12 + 1;
                
            } else { // 月份不等
                
                intervalMonthNum = (12 - startMonth + 1) + (currentYear - startYear - 1) * 12 + currentMonth;
            }
        }
    
    } else { // 回款签到时间间隔月
    
        NSInteger startYear = [self.rebackStartDate year];
        NSInteger startMonth = [self.rebackStartDate month];
        NSInteger currentYear = [self.currentDate year];
        NSInteger currentMonth = [self.currentDate month];
        
        if (startYear == currentYear) {
            
            intervalMonthNum = currentMonth - startMonth + 1;
            
        } else { // 年份不等
            
            if (startMonth == currentMonth) { // 月份相等
                
                intervalMonthNum = (currentYear - startYear) * 12 + 1;
                
            } else { // 月份不等
                
                intervalMonthNum = (12 - startMonth + 1) + (currentYear - startYear - 1) * 12 + currentMonth;
            }
        }

    
        intervalMonthNum += 12 * 3; //当前时间再后三年
    }
    
    return intervalMonthNum;
}

- (ZJCalendarModel *)getSelectedMonthModel
{
    return self.selectedMonthModel;
}

- (void)setRebackDateArrWithNil
{
    self.rebackDataArr = nil;
    self.selectedMonthModel = nil;
    self.selectedItemModel = nil;
}

//////////////////////////
#pragma mark - 更新视图方法
/////////////////////////////
// 根据选中月份改变数据
- (void)updateSelectedMonthModel:(ZJCalendarModel *)model withIndex:(NSInteger)index
{
    self.selectedMonthModel = model;
    
    if (self.block) {
        self.block(ZJCalendarTypeMonth, index, model.year);
    }
}

// 根据选中特定日期改变数据
- (void)updateSelectedItemModel:(ZJCalendarItemModel *)itemModel
{
    if (self.block) {
        self.itemBlock(itemModel);
    }
}

- (void)setCurrentDateModel:(ZJCalendarModel *)calendarModel
{
    
}


@end
