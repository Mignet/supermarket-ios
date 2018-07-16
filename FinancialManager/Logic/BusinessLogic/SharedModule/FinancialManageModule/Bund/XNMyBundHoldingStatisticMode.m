//
//  XNMyBundHoldingStatisticMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/21/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNMyBundHoldingStatisticMode.h"

@implementation XNMyBundHoldingStatisticMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNMyBundHoldingStatisticMode *mode = [[XNMyBundHoldingStatisticMode alloc] init];
        mode.currentAmount = [params objectForKey:XN_MY_BUND_HOLDING_STATISTIC_MODE_CURRENT_AMOUNT];
        mode.intransitAssets = [params objectForKey:XN_MY_BUND_HOLDING_STATISTIC_MODE_INTRANSIT_ASSETS];
        mode.investmentAmount = [params objectForKey:XN_MY_BUND_HOLDING_STATISTIC_MODE_INVESTMENT_AMOUNT];
        mode.profitLoss = [params objectForKey:XN_MY_BUND_HOLDING_STATISTIC_MODE_PROFIT_LOSS];
        mode.profitLossDaily = [params objectForKey:XN_MY_BUND_HOLDING_STATISTIC_MODE_PROFIT_LOSS_DAILY];
        mode.profitLossPercent = [params objectForKey:XN_MY_BUND_HOLDING_STATISTIC_MODE_PROFIT_LOSS_PERCENT];
        
        return mode;
    }
    return nil;
}

@end
