//
//  XNCSCustomerDetailMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/20.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNCSCfgDetailMode.h"

@implementation XNCSCfgDetailMode

+ (instancetype )initCfgDetailWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNCSCfgDetailMode * pd = [[XNCSCfgDetailMode alloc]init];
        
        pd.currInvestAmt = [params objectForKey:XN_CS_CUSTOMER_DETAIL_CURRINVESTAMT];
        pd.directRecomCfp = [params objectForKey:XN_CS_CFG_DIRECT_RECOM_CFP];
        pd.firstInvestTime = [params objectForKey:XN_CS_CUSTOMER_DETAIL_FIRSTINVESTTIME];
        pd.follow = [[params objectForKey:XN_CS_CUSTOMER_DETAIL_FOLLOW] boolValue];
        pd.grade = [params objectForKey:XN_CS_CFG_DETAIL_GRADE];
        pd.headImage = [params objectForKey:XN_CS_CUSTOMER_DETAIL_HEADIMAGE];
        pd.loginTime = [params objectForKey:XN_CS_CUSTOMER_DETAIL_LOGINTIME];
        pd.mobile = [params objectForKey:XN_CS_CUSTOMER_DETAIL_MOBILE];
        pd.registTime = [params objectForKey:XN_CS_CUSTOMER_DETAIL_REGISTTIME];
        pd.registeredOrgList = [params objectForKey:XN_CS_CUSTOMER_DETAIL_REGISTEREDORGLIST];
        pd.secondLevelCfp = [params objectForKey:XN_CS_CFG_SECONDLEVEL_CFG];
        pd.thisMonthIssueAmt = [params objectForKey:XN_CS_CUSTOMER_DETAIL_THIEMONTHINVESTAMT];
        pd.thisMonthProfit = [params objectForKey:XN_CS_CUSTOMER_DETAIL_THISMONTHPROFIT];
        pd.totalIssueAmt = [params objectForKey:XN_CS_CUSTOMER_DETAIL_TOTALINVESTAMT];
        pd.totalProfit = [params objectForKey:XN_CS_CFG_DETAIL_TOTAL_PROFIT];
        pd.userName = [params objectForKey:XN_CS_CUSTOMER_DETAIL_USERNAME];
        
        return pd;
    }
    return nil;
}
@end
