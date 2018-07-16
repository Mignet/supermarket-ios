//
//  XNBundItemMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNBundItemMode.h"

@implementation XNBundItemMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNBundItemMode *mode = [[XNBundItemMode alloc] init];
        mode.accumulateNav = [params objectForKey:XNBUND_ITEM_MODE_ACCUMULATENAV];
        mode.day1Performance = [params objectForKey:XNBUND_ITEM_MODE_DAY1_PERFORMANCE];
        mode.earningsPer10000 = [params objectForKey:XNBUND_ITEM_MODE_EARNINGS_PER10000];
        mode.fundCode = [params objectForKey:XNBUND_ITEM_MODE_FUND_CODE];
        mode.fundFullName = [params objectForKey:XNBUND_ITEM_MODE_FUND_FULL_NAME];
        
        mode.fundHouse = [params objectForKey:XNBUND_ITEM_MODE_FUND_HOUSE];
        mode.fundHouseCode = [params objectForKey:XNBUND_ITEM_MODE_FUND_HOUSE_CODE];
        mode.fundManagers = [params objectForKey:XNBUND_ITEM_MODE_FUND_MANAGERS];
        mode.fundName = [params objectForKey:XNBUND_ITEM_MODE_FUND_NAME];
        mode.fundSize = [params objectForKey:XNBUND_ITEM_MODE_FUND_SIZE];
        
        mode.fundStatus = [params objectForKey:XNBUND_ITEM_MODE_FUND_STATUS];
        mode.fundStatusMsg = [params objectForKey:XNBUND_ITEM_MODE_FUND_STATUS_MSG];
        mode.fundType = [params objectForKey:XNBUND_ITEM_MODE_FUND_TYPE];
        mode.fundTypeMsg = [params objectForKey:XNBUND_ITEM_MODE_FUND_TYPE_MSG];
        mode.geographicalSector = [params objectForKey:XNBUND_ITEM_MODE_GEOGRAPHICAL_SECTOR];
        mode.isBuyEnable = [params objectForKey:XNBUND_ITEM_MODE_IS_BUY_ENABLE];
        mode.isBuyEnableMsg = [params objectForKey:XNBUND_ITEM_MODE_IS_BUY_ENABLE_MSG];
        mode.isMMFund = [params objectForKey:XNBUND_ITEM_MODE_IS_MMFUND];
        mode.isMMFundMsg = [params objectForKey:XNBUND_ITEM_MODE_IS_MMFUND_MSG];
        
        mode.isQDII = [params objectForKey:XNBUND_ITEM_MODE_IS_QDII];
        mode.isQDIIMsg = [params objectForKey:XNBUND_ITEM_MODE_IS_QDII_MSG];
        mode.isRecommended = [params objectForKey:XNBUND_ITEM_MODE_IS_RECOMMENDED];
        mode.isRecommendedMsg = [params objectForKey:XNBUND_ITEM_MODE_IS_RECOMMENDED_MSG];
        mode.month3 = [params objectForKey:XNBUND_ITEM_MODE_MONTH3];
        mode.nav = [params objectForKey:XNBUND_ITEM_MODE_NAV];
        mode.navDate = [params objectForKey:XNBUND_ITEM_MODE_NAVDATE];
        
        mode.riskRate = [params objectForKey:XNBUND_ITEM_MODE_RISK_RATE];
        mode.riskRateMsg = [params objectForKey:XNBUND_ITEM_MODE_RISK_RATE_MSG];
        mode.sevenDaysAnnualizedYield = [params objectForKey:XNBUND_ITEM_MODE_SEVEN_DAYS_ANNUALIZED_YIELD];
        mode.sinceLaunch = [params objectForKey:XNBUND_ITEM_MODE_SINCE_LAUNCH];
        mode.specializeSector = [params objectForKey:XNBUND_ITEM_MODE_SPECIALIZE_SECTOR];
        mode.year1 = [params objectForKey:XNBUND_ITEM_MODE_YEAR1];
        
        mode.year3 = [params objectForKey:XNBUND_ITEM_MODE_YEAR3];
        mode.year5 = [params objectForKey:XNBUND_ITEM_MODE_YEAR5];
        
        mode.month3Msg = [params objectForKey:XNBUND_ITEM_MODE_MONTH3_MSG];
        mode.year1Msg = [params objectForKey:XNBUND_ITEM_MODE_YEAR1_MSG];
        mode.year3Msg = [params objectForKey:XNBUND_ITEM_MODE_YEAR3_MSG];
        mode.year5Msg = [params objectForKey:XNBUND_ITEM_MODE_YEAR5_MSG];
        mode.sinceLaunchMsg = [params objectForKey:XNBUND_ITEM_MODE_SINCE_LAUNCH_MSG];
        mode.earningsPer10000Msg = [params objectForKey:XNBUND_ITEM_MODE_EARNINGSPER10000MSG];
        mode.navMsg = [params objectForKey:XNBUND_ITEM_MODE_NAV_MSG];
        mode.sevenDaysAnnualizedYield = [params objectForKey:XNBUND_ITEM_MODE_SEVEN_DAYS_ANNUALIZED_YIELD];
        
        return mode;
    }
    return nil;
}

@end
