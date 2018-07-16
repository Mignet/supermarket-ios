//
//  XNMyBundHoldingStatisticMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/21/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MY_BUND_HOLDING_STATISTIC_MODE_CURRENT_AMOUNT @"currentAmount"
#define XN_MY_BUND_HOLDING_STATISTIC_MODE_INTRANSIT_ASSETS @"intransitAssets"
#define XN_MY_BUND_HOLDING_STATISTIC_MODE_INVESTMENT_AMOUNT @"investmentAmount"
#define XN_MY_BUND_HOLDING_STATISTIC_MODE_PROFIT_LOSS @"profitLoss"
#define XN_MY_BUND_HOLDING_STATISTIC_MODE_PROFIT_LOSS_DAILY @"profitLossDaily"
#define XN_MY_BUND_HOLDING_STATISTIC_MODE_PROFIT_LOSS_PERCENT @"profitLossPercent"

@interface XNMyBundHoldingStatisticMode : NSObject

@property (nonatomic, strong) NSString *currentAmount; //总资产现值(元)
@property (nonatomic, strong) NSString *intransitAssets; //	在途资产
@property (nonatomic, strong) NSString *investmentAmount; //总资产成本(元)
@property (nonatomic, strong) NSString *profitLoss; //	盈利/亏损(元)
@property (nonatomic, strong) NSString *profitLossDaily; //	昨日收益
@property (nonatomic, strong) NSString *profitLossPercent; //	盈利/亏损(%)

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
