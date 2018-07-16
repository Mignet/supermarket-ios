//
//  XNInvestStatisticIitem.m
//  FinancialManager
//
//  Created by xnkj on 16/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNInvestStatisticItem.h"

@implementation XNInvestStatisticItem

+ (XNInvestStatisticItem *)initInvestStatistItemWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNInvestStatisticItem * pd = [[XNInvestStatisticItem alloc]init];
        
        pd.orgName = [params objectForKey:XN_MYINFO_INVEST_STATISTIC_ITEM_ORGNAME];
        pd.totalPercent = [params objectForKey:XN_MYINFO_INVEST_STATISTIC_ITEM_TOTALPERCENT];
        
        return pd;
    }
    return nil;
}

@end
