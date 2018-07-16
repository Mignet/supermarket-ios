//
//  MIMonthProfixMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/24/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIMonthProfixMode.h"

@implementation MIMonthProfixMode

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        MIMonthProfixMode *pd = [[MIMonthProfixMode alloc] init];
        
        pd.grantedAmount = [params objectForKey:XN_MONTH_PROFIX_MODE_GRANTED_AMOUNT];
        pd.waitGrantAmount = [params objectForKey:XN_MONTH_PROFIX_MODE_WAIT_GRANT_AMOUNT];
        pd.totalProfix = [params objectForKey:XN_MONTH_PROFIX_MODE_GRANT_TOTAL_PROFIX];
        pd.profixList = [params objectForKey:XN_MONTH_PROFIX_MODE_GRANT_PROFIX_LIST];
        
        return pd;
    }
    return nil;
}



@end
