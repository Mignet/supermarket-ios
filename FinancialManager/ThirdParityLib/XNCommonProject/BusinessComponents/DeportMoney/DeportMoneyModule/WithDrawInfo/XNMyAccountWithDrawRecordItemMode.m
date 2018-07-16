//
//  NXMyAccountDeportRecordItemMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNMyAccountWithDrawRecordItemMode.h"

@implementation XNMyAccountWithDrawRecordItemMode

+ (instancetype )initWithDrawRecordItemWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNMyAccountWithDrawRecordItemMode * pd = [[XNMyAccountWithDrawRecordItemMode alloc]init];
        
        pd.userId = [params objectForKey:XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_USERID];
        pd.userName = [params objectForKey:XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_USERNAME];
        pd.bisName = [params objectForKey:XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_BISNAME];
        pd.paymentDate = [params objectForKey:XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_BISTIME];
        pd.transDate = [params objectForKey:XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_TRANSDATE];
        pd.amount = [NSString stringWithFormat:@"%@",[params objectForKey:XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_AMOUNT]];
        pd.fee = [NSString stringWithFormat:@"%@",[params objectForKey:XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_FEE]];
        pd.status = [params objectForKey:XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_STATUS];
        pd.userType = [params objectForKey:XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_USERTYPE];
        pd.failureCause = [params objectForKey:XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_FAILURE_CAUSE];
        
        return pd;
    }
    return nil;
}
@end
