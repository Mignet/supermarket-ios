//
//  MIAccountBalanceProfixItemMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/24/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIAccountBalanceProfixItemMode.h"

@implementation MIAccountBalanceProfixItemMode

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        MIAccountBalanceProfixItemMode *mode = [[MIAccountBalanceProfixItemMode alloc] init];
        mode.grantDesc = [params objectForKey:XN_ACCOUNT_BALANCE_PROFIX_ITEM_MODE_GRANT_DESC];
        mode.month = [params objectForKey:XN_ACCOUNT_BALANCE_PROFIX_ITEM_MODE_MONTH];
        mode.monthDesc = [params objectForKey:XN_ACCOUNT_BALANCE_PROFIX_ITEM_MODE_MONTH_DESC];
        mode.totalAmount = [params objectForKey:XN_ACCOUNT_BALANCE_PROFIX_ITEM_MODE_TOTAL_AMOUNT];
        return mode;
    }
    return nil;
}

@end
