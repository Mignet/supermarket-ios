//
//  MIInvestRecordItemMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 6/26/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNCSMyCustomerInvestRecordItemMode.h"

@implementation XNCSMyCustomerInvestRecordItemMode

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNCSMyCustomerInvestRecordItemMode *pd = [[XNCSMyCustomerInvestRecordItemMode alloc] init];
        
        pd.feeAmountSum = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_FEEAMOUNT];
        pd.headImage = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_HEADIAMGE];
        pd.investAmt = [NSString stringWithFormat:@"%@",[params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_INVESTAMT]];
        pd.platformName = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_PLATFORMNAME];
        pd.startTime = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_INVESTTIME];
        pd.userName = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_USERNAME];
        pd.userType = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_USERTYPE];
        pd.investId = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_INVESTID];
        
        return pd;
    }
    return nil;
}


@end
