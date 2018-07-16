//
//  XNMyBundHoldingDetailMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/21/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MY_BUND_HOLDING_DETAIL_MODE_AVAILABLE_UNIT @"availableUnit"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_CHARGE_MODE @"chargeMode"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_CURRENT_VALUE @"currentValue"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_DIVIDEN_CASH @"dividendCash"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_DIVIDEND_INSTRUCTION @"dividendInstruction"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_FUND_CODE @"fundCode"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_FUND_NAME @"fundName"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_INTRANSIT_ASSETS @"intransitAssets"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_INVESTMENT_AMOUNT @"investmentAmount"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_NAV @"nav"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_NAV_DATE @"navDate"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_PREVIOUS_PROFIT_NLOSS @"previousProfitNLoss"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_PROFIT_NLOSS @"profitNLoss"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_TOTAL_UNIT @"totalUnit"
#define XN_MY_BUND_HOLDING_DETAIL_MODE_UNDISTRIBUTE_MONETARY_INCOME @"undistributeMonetaryIncome"

@interface XNMyBundHoldingDetailMode : NSObject

@property (nonatomic, strong) NSString *availableUnit; //基金可处理份额
@property (nonatomic, strong) NSString *chargeMode; //	收费模式
@property (nonatomic, strong) NSString *currentValue;//资产现值
@property (nonatomic, strong) NSString *dividendCash; //持有的基金目前为止收到的所有现金分红
@property (nonatomic, strong) NSString *dividendInstruction; //分红方式
@property (nonatomic, strong) NSString *fundCode; //基金代码
@property (nonatomic, strong) NSString *fundName; //	基金简称
@property (nonatomic, strong) NSString *intransitAssets; //在途资产
@property (nonatomic, strong) NSString *investmentAmount; //资产成本
@property (nonatomic, strong) NSString *nav; //最新净值
@property (nonatomic, strong) NSString *navDate; //净值日期
@property (nonatomic, strong) NSString *previousProfitNLoss; //昨日收益
@property (nonatomic, strong) NSString *profitNLoss; //盈利/亏损
@property (nonatomic, strong) NSString *totalUnit; //基金持有总份额
@property (nonatomic, strong) NSString *undistributeMonetaryIncome; //未分配收益

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
