//
//  MIAccountBalanceDetailMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 2/14/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MIAccountBalanceDetailMode.h"

@implementation MIAccountBalanceDetailMode

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        MIAccountBalanceDetailMode *pd = [[MIAccountBalanceDetailMode alloc] init];
        pd.accountBalance = [params objectForKey:XN_ACCOUNT_BALANCE_DETAIL_MODE_ACCOUNT_BALANCE];
        pd.incomeSummary = [params objectForKey:XN_ACCOUNT_BALANCE_DETAIL_MODE_INCOME_SUMMARY];
        pd.outSummary = [params objectForKey:XN_ACCOUNT_BALANCE_DETAIL_MODE_OUT_SUMMARY];
        
        return pd;
    }
    return nil;
}

@end
