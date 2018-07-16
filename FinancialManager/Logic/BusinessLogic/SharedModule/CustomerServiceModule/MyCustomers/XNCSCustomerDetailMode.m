//
//  XNCSCustomerDetailMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/20.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNCSCustomerDetailMode.h"

@implementation XNCSCustomerDetailMode

+ (instancetype )initCustomerDetailWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNCSCustomerDetailMode * pd = [[XNCSCustomerDetailMode alloc]init];
        
        pd.userId = [params objectForKey:XN_CS_CUSTOMER_DETAIL_USERID];
        pd.userName = [params objectForKey:XN_CS_CUSTOMER_DETAIL_USERNAME];
        pd.currInvestAmt = [params objectForKey:XN_CS_CUSTOMER_DETAIL_CURRINVESTAMT];
        pd.follow = [[params objectForKey:XN_CS_CUSTOMER_DETAIL_FOLLOW] boolValue];
        pd.firstInvestTime = [params objectForKey:XN_CS_CUSTOMER_DETAIL_FIRSTINVESTTIME];
        pd.headImage = [params objectForKey:XN_CS_CUSTOMER_DETAIL_HEADIMAGE];
        pd.loginTime = [params objectForKey:XN_CS_CUSTOMER_DETAIL_LOGINTIME];
        pd.mobile = [params objectForKey:XN_CS_CUSTOMER_DETAIL_MOBILE];
        pd.registTime = [params objectForKey:XN_CS_CUSTOMER_DETAIL_REGISTTIME];
        pd.thisMonthInvestAmt = [params objectForKey:XN_CS_CUSTOMER_DETAIL_THIEMONTHINVESTAMT];
        pd.thisMonthProfit = [params objectForKey:XN_CS_CUSTOMER_DETAIL_THISMONTHPROFIT];
        pd.totalInvestAmt = [params objectForKey:XN_CS_CUSTOMER_DETAIL_TOTALINVESTAMT];
        pd.caredStatus =[[params objectForKey:XN_CS_CUSTOMER_DETAIL_CAREDSTASTUS] boolValue];
        pd.registeredOrgList = [params objectForKey:XN_CS_CUSTOMER_DETAIL_REGISTEREDORGLIST];
        pd.totalProfit = [params objectForKey:XN_CS_CUSTOMER_DETAIL_TOTALPROFIT];
        
        
        return pd;
    }
    return nil;
}
@end
