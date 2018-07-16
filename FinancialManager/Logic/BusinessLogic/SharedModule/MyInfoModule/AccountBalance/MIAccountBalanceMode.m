//
//  MIAccountBalanceMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIAccountBalanceMode.h"

@implementation MIAccountBalanceMode

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        MIAccountBalanceMode *pd = [[MIAccountBalanceMode alloc] init];
        pd.accountBalance = [params objectForKey:XN_MYINFO_ACCOUNT_BALANCE_MODE_ACCOUNT_BALANCE];
        pd.totalProfix = [params objectForKey:XN_MYINFO_ACCOUNT_BALANCE_MODE_TOTAL_PROFIX];
        pd.profixList = [params objectForKey:XN_MYINFO_ACCOUNT_BALANCE_MODE_PROFIX_LIST];
        
        return pd;
    }
    return nil;
}

@end
