//
//  XNCSHomePageMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/20.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNCSHomePageMode.h"

@implementation XNCSHomePageMode

+ (instancetype )initCSHomePageWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNCSHomePageMode * pd = [[XNCSHomePageMode alloc]init];
        
        pd.dayInvestAmt = [params objectForKey:XN_CS_HOMEPAGE_DAYINVESTAMT];
        pd.hasCustomer = [params objectForKey:XN_CS_HOMEPAGE_HASCUSTOMER];
        pd.hasTeamMembers = [params objectForKey:XN_CS_HOMEPAGE_HASTEAMMEMBERS];
        pd.level = [params objectForKey:XN_CS_HOMEPAGE_LEVEL];
        pd.minTime = [params objectForKey:XN_CS_HOMEPAGE_MINTIME];
        pd.monthInvestAmt = [params objectForKey:XN_CS_HOMEPAGE_MONTHINVESTAMT];
        pd.backtradeCount = [params objectForKey:XN_CS_HOMEPAGE_NEWBACKTRADECOUNT];
        pd.buytradeCount = [params objectForKey:XN_CS_HOMEPAGE_NEWBUYTRADECOUNT];
        pd.tradeCount = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[pd.backtradeCount integerValue] + [pd.buytradeCount integerValue]]];
        pd.customerCount = [params objectForKey:XN_CS_HOMEPAGE_NEWCUSTOMERCOUNT];
        pd.msgCount = [params objectForKey:XN_CS_HOMEPAGE_NEWMESSAGECOUNT];
        pd.teamCount = [params objectForKey:XN_CS_HOMEPAGE_TEAMCOUNT];
        pd.thisMonthAllowance = [params objectForKey:XN_CS_HOMEPAGE_THIEMONTHALLOWANCE];
        pd.thisMonthFee = [params objectForKey:XN_CS_HOMEPAGE_THISMONTHFEE];
        pd.thisMonthTeamSaleAmount = [params objectForKey:XN_CS_HOMEPAGE_THISMONTHTEAMSALEAMOUNT];
        pd.totalInvestAmt = [params objectForKey:XN_CS_HOMEPAGE_TOTALINVESTAMT];
        pd.leaderProfit = [params objectForKey:XN_CS_HOMEPAGE_LEADERPROFIT];
        pd.feeMonth = [NSString stringWithFormat:@"%@", [params objectForKey:XN_CS_HOMEPAGE_FEEMONTH] == nil ? @"上" : [params objectForKey:XN_CS_HOMEPAGE_FEEMONTH]];
        
        return pd;
    }
    return nil;
}
@end
