//
//  CalendarManager.m
//  FinancialManager
//
//  Created by xnkj on 19/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "CalendarManager.h"

@interface CalendarManager()

@property (nonatomic, assign) NSInteger unitFlags;
@property (nonatomic, strong) NSCalendar * calendar;
@end

@implementation CalendarManager

//由于比较耗用性能，故创建单例
+ (instancetype)defaultManager
{
    static CalendarManager * defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        defaultManager = [[CalendarManager alloc]init];
        
        if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
             defaultManager.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];//设置成中国阳历
        }else{
            defaultManager.calendar = [NSCalendar currentCalendar];
        }
    
        defaultManager.unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    });
    
    return defaultManager;
}

#pragma mark - 创建 NSDateComponents
- (NSDateComponents *)dateComponentsWithDate:(NSDate *)date
{
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    currentComps = [self.calendar components:self.unitFlags fromDate:date];
    
    return currentComps;
}

@end
