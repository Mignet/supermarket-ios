//
//  MIInvestRecordItemMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 6/26/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MIInvestRecordItemMode.h"

@implementation MIInvestRecordItemMode

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        MIInvestRecordItemMode *pd = [[MIInvestRecordItemMode alloc] init];
        
        if ([NSObject isValidateObj:[params objectForKey:@"clearingStatus"]]) {
            pd.clearingStatus = [NSString stringWithFormat:@"%@",[params objectForKey:@"clearingStatus"]];
        }
        
        pd.feeAmountSum = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_FEEAMOUNTSUM];
        pd.headImage = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_HEADIAMGE];
        pd.investAmt = [NSString stringWithFormat:@"%@",[params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_INVESTAMT]];
        pd.investId = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_INVESTID];
        pd.platformName = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_PLATFORMNAME];
        pd.startTime = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_STARTTIME];
        pd.startTimeStr = [NSString stringWithFormat:@"%@", [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_STARTTIMESTR]];
        pd.userName = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_USERNAME];
        pd.userType = [params objectForKey:XN_MYINFO_INVEST_RECORD_ITEM_USERTYPE];
        
        return pd;
    }
    return nil;
}


@end
