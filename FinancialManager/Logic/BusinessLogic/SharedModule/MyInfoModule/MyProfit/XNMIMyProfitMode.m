//
//  XNMIMyProfitMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNMIMyProfitMode.h"

@implementation XNMIMyProfitMode

+ (instancetype )initMyProfitWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNMIMyProfitMode * pd = [[XNMIMyProfitMode alloc]init];
        
        pd.minTime = [params objectForKey:XN_MYINFO_MYPROFIT_MINTIME];
        pd.dayProfit = [NSString stringWithFormat:@"%@",[params objectForKey:XN_MYINFO_MYPROFIT_DAYPROFIT]];
        pd.sumProfit = [NSString stringWithFormat:@"%@",[params objectForKey:XN_MYINFO_MYPROFIT_MONTHPROFIT]];
        pd.totalProfit = [NSString stringWithFormat:@"%@",[params objectForKey:XN_MYINFO_MYPROFIT_TOTALPROFIT]];
        pd.profitsArray = [params objectForKey:XN_MYINFO_MYPROFIT_PROFITS];
        
        return pd;
    }
    return nil;
}

@end
