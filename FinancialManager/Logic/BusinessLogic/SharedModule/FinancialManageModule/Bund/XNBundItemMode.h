//
//  XNBundItemMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XNBUND_ITEM_MODE_ACCUMULATENAV @"accumulateNav"
#define XNBUND_ITEM_MODE_DAY1_PERFORMANCE @"day1Performance"
#define XNBUND_ITEM_MODE_EARNINGS_PER10000 @"earningsPer10000"
#define XNBUND_ITEM_MODE_FUND_CODE @"fundCode"
#define XNBUND_ITEM_MODE_FUND_FULL_NAME @"fundFullName"

#define XNBUND_ITEM_MODE_FUND_HOUSE @"fundHouse"
#define XNBUND_ITEM_MODE_FUND_HOUSE_CODE @"fundHouseCode"
#define XNBUND_ITEM_MODE_FUND_MANAGERS @"fundManagers"
#define XNBUND_ITEM_MODE_FUND_NAME @"fundName"
#define XNBUND_ITEM_MODE_FUND_SIZE @"fundSize"

#define XNBUND_ITEM_MODE_FUND_STATUS @"fundStatus"
#define XNBUND_ITEM_MODE_FUND_STATUS_MSG @"fundStatusMsg"
#define XNBUND_ITEM_MODE_FUND_TYPE @"fundType"
#define XNBUND_ITEM_MODE_FUND_TYPE_MSG @"fundTypeMsg"
#define XNBUND_ITEM_MODE_GEOGRAPHICAL_SECTOR @"geographicalSector"
#define XNBUND_ITEM_MODE_IS_BUY_ENABLE @"isBuyEnable"
#define XNBUND_ITEM_MODE_IS_BUY_ENABLE_MSG @"isBuyEnableMsg"
#define XNBUND_ITEM_MODE_IS_MMFUND @"isMMFund"
#define XNBUND_ITEM_MODE_IS_MMFUND_MSG @"isMMFundMsg"

#define XNBUND_ITEM_MODE_IS_QDII @"isQDII"
#define XNBUND_ITEM_MODE_IS_QDII_MSG @"isQDIIMsg"
#define XNBUND_ITEM_MODE_IS_RECOMMENDED @"isRecommended"
#define XNBUND_ITEM_MODE_IS_RECOMMENDED_MSG @"isRecommendedMsg"
#define XNBUND_ITEM_MODE_MONTH3 @"month3"
#define XNBUND_ITEM_MODE_NAV @"nav"
#define XNBUND_ITEM_MODE_NAVDATE @"navDate"

#define XNBUND_ITEM_MODE_RISK_RATE @"riskRate"
#define XNBUND_ITEM_MODE_RISK_RATE_MSG @"riskRateMsg"
#define XNBUND_ITEM_MODE_SEVEN_DAYS_ANNUALIZED_YIELD @"sevenDaysAnnualizedYield"
#define XNBUND_ITEM_MODE_SINCE_LAUNCH @"sinceLaunch"
#define XNBUND_ITEM_MODE_SPECIALIZE_SECTOR @"specializeSector"
#define XNBUND_ITEM_MODE_YEAR1 @"year1"

#define XNBUND_ITEM_MODE_YEAR3 @"year3"
#define XNBUND_ITEM_MODE_YEAR5 @"year5"

#define XNBUND_ITEM_MODE_MONTH3_MSG @"month3Msg"
#define XNBUND_ITEM_MODE_YEAR1_MSG @"year1Msg"
#define XNBUND_ITEM_MODE_YEAR3_MSG @"year3Msg"
#define XNBUND_ITEM_MODE_YEAR5_MSG @"year5Msg"
#define XNBUND_ITEM_MODE_SINCE_LAUNCH_MSG @"sinceLaunchMsg"
#define XNBUND_ITEM_MODE_EARNINGSPER10000MSG @"earningsPer10000Msg"
#define XNBUND_ITEM_MODE_NAV_MSG @"navMsg"
#define XNBUND_ITEM_MODE_SEVENDAYSANNUALIZEDYIELD_MSG @"sevenDaysAnnualizedYieldMsg"

@interface XNBundItemMode : NSObject

@property (nonatomic, strong) NSString *accumulateNav; //累计净值
@property (nonatomic, strong) NSString *day1Performance; //日涨幅
@property (nonatomic, strong) NSString *earningsPer10000; //货币型基金的最新万份收益
@property (nonatomic, strong) NSString *fundCode; //基金代码
@property (nonatomic, strong) NSString *fundFullName; //基金全称

@property (nonatomic, strong) NSString *fundHouse; //基金公司名称
@property (nonatomic, strong) NSString *fundHouseCode; //基金公司代码
@property (nonatomic, strong) NSString *fundManagers; //基金经理列表 格式{基金经理代码：基金经理名称,...}
@property (nonatomic, strong) NSString *fundName; //基金简称
@property (nonatomic, strong) NSString *fundSize; //基金最新规模 单位为亿

@property (nonatomic, strong) NSString *fundStatus; //基金状态 (0=募集期基金；1=申购期基金；2=封闭期基金；3=已清盘的基金。该接口不返回其他状态的基金)
@property (nonatomic, strong) NSString *fundStatusMsg; //fundStatus 文字转换

@property (nonatomic, strong) NSString *fundType; //基金类型代码 (MM：货币型；BOND：债券型；MIXED：混合型；CP：保本型；EQ：股票型；AI：另类型；INDEX：指数型；ST：分级型；UNKNOWN：其他)
@property (nonatomic, strong) NSString *fundTypeMsg; //fundType 文字转换

@property (nonatomic, strong) NSString *geographicalSector; //地理属性
@property (nonatomic, strong) NSString *isBuyEnable; //是否可以购买(0=可以购买，1=不能购买)
@property (nonatomic, strong) NSString *isBuyEnableMsg; //isBuyEnable 文字转换

@property (nonatomic, strong) NSString *isMMFund; //是否是货币型基金(0=货币型基金，1=非货币型基金)
@property (nonatomic, strong) NSString *isMMFundMsg; //isMMFund 文字转换

@property (nonatomic, strong) NSString *isQDII; //是否是QDII基金(	0=QDII，1=非QDII)
@property (nonatomic, strong) NSString *isQDIIMsg; //isQDII 文字转换

@property (nonatomic, strong) NSString *isRecommended; //是否是奕丰推荐基金(0=奕丰推荐基金，1=非奕丰推荐基金)
@property (nonatomic, strong) NSString *isRecommendedMsg; //isRecommended 文字转换


@property (nonatomic, strong) NSString *month3; //近3个月的收益
@property (nonatomic, strong) NSString *nav; //最新净值
@property (nonatomic, strong) NSString *navDate; //最新净值日期

@property (nonatomic, strong) NSString *riskRate; //基金的风险等级(1=低风险；2=中低风险；3=中风险；4=中高风险；5=高风险)
@property (nonatomic, strong) NSString *riskRateMsg; //riskRate 文字转换
@property (nonatomic, strong) NSString *sevenDaysAnnualizedYield; //货币型基金的七日年化收益
@property (nonatomic, strong) NSString *sinceLaunch; //成立以来的收益
@property (nonatomic, strong) NSString *specializeSector; //行业属性
@property (nonatomic, strong) NSString *year1; //近1年的收益

@property (nonatomic, strong) NSString *year3; //近3年的收益
@property (nonatomic, strong) NSString *year5; //近5年的收益

//经过转化的数据
@property (nonatomic, strong) NSString *month3Msg; //近3个月的收益,转换
@property (nonatomic, strong) NSString *year1Msg; //近1年的收益,转换
@property (nonatomic, strong) NSString *year3Msg; //近3年的收益,转换
@property (nonatomic, strong) NSString *year5Msg; //近5年的收益,转换
@property (nonatomic, strong) NSString *sinceLaunchMsg; //成立以来的收益,转换
@property (nonatomic, strong) NSString *earningsPer10000Msg;
@property (nonatomic, strong) NSString *navMsg;

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
