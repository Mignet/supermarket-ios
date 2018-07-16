//
//  MIAccountBalanceDetailListMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 2/14/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MIAccountBalanceDetailItemMode.h"

@implementation MIAccountBalanceDetailItemMode

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        MIAccountBalanceDetailItemMode *pd = [[MIAccountBalanceDetailItemMode alloc] init];
        pd.amount = [params objectForKey:XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_AMOUNT];
        pd.remark = [params objectForKey:XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_REMARK];
        pd.tranName = [params objectForKey:XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_TRAN_NAME];
        pd.userType = [params objectForKey:XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_USER_TYPE];
        pd.tranTime = [params objectForKey:XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_TRAN_TIME];
        pd.status = [params objectForKey:XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_STATUS];
        pd.withdrawRemark = [params objectForKey:XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_WITHDRAW_REMARK];
        pd.failureCause = [params objectForKey:XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_FAILURE_CAUSE];
        
        return pd;
    }
    return nil;
}


@end
