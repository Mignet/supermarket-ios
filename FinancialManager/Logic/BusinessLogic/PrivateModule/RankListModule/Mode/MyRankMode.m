//
//  MyRankMode.m
//  FinancialManager
//
//  Created by xnkj on 22/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyRankMode.h"

@implementation MyRankMode

+ (instancetype)initMyRankWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        MyRankMode * pd = [[MyRankMode alloc]init];
        
        pd.headImageStr = [NSString stringWithFormat:@"%@",[params objectForKey:XN_HOME_RANKLIST_MYRANK_HEADIMAGE]];
        pd.mobile = [NSString stringWithFormat:@"%@",[params objectForKey:XN_HOME_RANKLIST_MYRANK_MOBILE]];
        pd.rank = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[[params objectForKey:XN_HOME_RANKLIST_MYRANK_RANK] integerValue]]];
        pd.totalProfit = [NSString stringWithFormat:@"%@", [params objectForKey:XN_HOME_RANKLIST_MYRANK_TOTALPROFIT]];
        pd.levelName = [NSString stringWithFormat:@"%@",[params objectForKey:XN_HOME_RANKLIST_MYRANK_LEVEL_NAME]];
        
        return pd;
    }
    return nil;
}

@end
