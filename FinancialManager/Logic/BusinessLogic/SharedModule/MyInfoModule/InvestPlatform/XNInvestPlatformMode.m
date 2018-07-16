//
//  XNInvestPlatformmode.m
//  FinancialManager
//
//  Created by xnkj on 29/06/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNInvestPlatformMode.h"
#import "XNInvestPlatformDetailMode.h"
#import "XNInvestStatisticItem.h"

@implementation XNInvestPlatformMode

+ (instancetype)initInvestPlatformWithParams:(NSDictionary *)params
{
    if (params) {
        
        XNInvestPlatformMode * pd = [[XNInvestPlatformMode alloc]init];
        
        pd.investingAmt = [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTING_AMT];
        pd.investingPlatformNum = [NSString stringWithFormat:@"%@",[params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTINGPLATFORMNUM]];
        pd.investingProfit = [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTING_PROFIT];
        pd.totalProfit = [params objectForKey:XN_MYINFO_INVEST_TOTAL_PROFIT];
        pd.yearProfitRate = [params objectForKey:XN_MYINFO_INVEST_YEAR_PROFIT_RATE];
        
        NSMutableArray * percentArray = [NSMutableArray array];
        XNInvestStatisticItem * percentMode = nil;
        for (NSDictionary * param in [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTINGSTATISTICLIST]){
            
            percentMode = [XNInvestStatisticItem initInvestStatistItemWithParams:param];
            
            [percentArray addObject:percentMode];
        }
        pd.investStatisticList = percentArray;
        
        NSMutableArray * array = [NSMutableArray array];
        XNInvestPlatformDetailMode * mode = nil;
        for (NSDictionary * param in [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORMLIST]) {
            
            mode = [XNInvestPlatformDetailMode initInvestPlatformDetailWithParams:param];
            
            [array addObject:mode];
        }
        pd.investPlatformList = array;
        
        return pd;
    }
    return nil;
}
@end
