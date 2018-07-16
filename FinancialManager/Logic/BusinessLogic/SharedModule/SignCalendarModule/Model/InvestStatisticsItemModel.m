//
//  InvestStatisticsItemModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/29.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "InvestStatisticsItemModel.h"

@implementation InvestStatisticsItemModel

+ (instancetype)investStatisticsItemModelWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        InvestStatisticsItemModel *pd = [[InvestStatisticsItemModel alloc] init];
        
        pd.calendarNumber = [NSString stringWithFormat:@"%@",[params objectForKey:@"calendarNumber"]];
        
        NSString *calendarTime = [params objectForKey:@"calendarTime"];
        
        pd.calendarTime = calendarTime;
        
        if (calendarTime.length > 0) { //年-月-日
            
            NSArray *array = [calendarTime componentsSeparatedByString:@"-"];
            if (pd.year.length == 0 && pd.month.length == 0) {
                pd.year = [array firstObject];
                pd.month = [array objectAtIndex:1];
                pd.day = [array lastObject];
            }
        }
        
        return pd;
    }
    return nil;
}

@end
