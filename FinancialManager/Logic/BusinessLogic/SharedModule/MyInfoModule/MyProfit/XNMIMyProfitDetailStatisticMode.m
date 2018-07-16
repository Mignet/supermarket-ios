//
//  XNMIMyProfitDetailStatisticMode.m
//  FinancialManager
//
//  Created by xnkj on 1/13/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNMIMyProfitDetailStatisticMode.h"

@implementation XNMIMyProfitDetailStatisticMode

+ (instancetype )initMyProfitDetailStatisticWithParams:(NSDictionary *)params
{
    if (params) {
        
        XNMIMyProfitDetailStatisticMode * pd = [[XNMIMyProfitDetailStatisticMode alloc]init];
        
        pd.totalProfit = [NSString stringWithFormat:@"%@",[params objectForKey:XN_MYINFO_MYPROFIT_DETAIL_STATISTIC_TOTALPROFIT]];
        
        return pd;
    }
    return nil;
}
@end
