//
//  XNInvestPlatformmode.h
//  FinancialManager
//
//  Created by xnkj on 29/06/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MYINFO_INVEST_PLATFORM_INVESTING_AMT @"investingAmt"
#define XN_MYINFO_INVEST_PLATFORM_INVESTING_PROFIT @"investingProfit"
#define XN_MYINFO_INVEST_PLATFORM_INVESTINGPLATFORMNUM @"investingPlatformNum"
#define XN_MYINFO_INVEST_TOTAL_PROFIT @"totalProfit"
#define XN_MYINFO_INVEST_YEAR_PROFIT_RATE @"yearProfitRate"

#define XN_MYINFO_INVEST_PLATFORM_INVESTINGSTATISTICLIST @"investingStatisticList"
#define XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORMLIST @"platformInvestStatisticsList"

@interface XNInvestPlatformMode : NSObject

@property (nonatomic, strong) NSString * investingAmt;
@property (nonatomic, strong) NSString * investingPlatformNum;
@property (nonatomic, strong) NSString * investingProfit;
@property (nonatomic, strong) NSString * totalProfit;
@property (nonatomic, strong) NSString * yearProfitRate;

@property (nonatomic, strong) NSArray  * investStatisticList;
@property (nonatomic, strong) NSArray  * investPlatformList;

+ (instancetype)initInvestPlatformWithParams:(NSDictionary *)params;
@end
