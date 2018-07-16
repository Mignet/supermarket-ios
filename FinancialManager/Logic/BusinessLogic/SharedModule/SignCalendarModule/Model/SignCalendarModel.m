//
//  SignCalendarModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignCalendarModel.h"

@implementation SignCalendarModel

+ (instancetype)signCalendarModelWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        SignCalendarModel *pd = [[SignCalendarModel alloc] init];
        pd.data = [NSMutableArray arrayWithCapacity:0];
        
        NSArray *dateArr = [params objectForKey:Sign_Calendar_Model_datas];
        if ([dateArr count] > 0) {
            for (NSString *dateStr in dateArr) {
                NSArray *array = [dateStr componentsSeparatedByString:@"-"];
                if (pd.year.length == 0 && pd.month.length == 0) {
                    pd.year = [array firstObject];
                    pd.month = [array objectAtIndex:1];
                }
                [pd.data addObject:[array lastObject]];
            }
            return pd;
            
        } else {
        
            return nil;
        }
    }
    return nil;
}

/***
 datas =         (
 "2017-11-22",
 "2017-11-23",
 "2017-11-24"
 );

 **/

@end
