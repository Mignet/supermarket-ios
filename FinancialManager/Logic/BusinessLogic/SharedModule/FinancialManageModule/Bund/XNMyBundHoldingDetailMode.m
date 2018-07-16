//
//  XNMyBundHoldingDetailMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/21/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNMyBundHoldingDetailMode.h"

@implementation XNMyBundHoldingDetailMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNMyBundHoldingDetailMode *mode = [[XNMyBundHoldingDetailMode alloc] init];
        
        mode.availableUnit = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_AVAILABLE_UNIT];
        mode.chargeMode = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_CHARGE_MODE];
        mode.currentValue = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_CURRENT_VALUE];
        mode.dividendCash = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_DIVIDEN_CASH];
        mode.dividendInstruction = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_DIVIDEND_INSTRUCTION];
        mode.fundCode = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_FUND_CODE];
        mode.fundName = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_FUND_NAME];
        mode.intransitAssets = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_INTRANSIT_ASSETS];
        mode.investmentAmount = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_INVESTMENT_AMOUNT];
        mode.nav = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_NAV];
        mode.navDate = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_NAV_DATE];
        mode.previousProfitNLoss = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_PREVIOUS_PROFIT_NLOSS];
        mode.profitNLoss = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_PROFIT_NLOSS];
        mode.totalUnit = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_TOTAL_UNIT];
        mode.undistributeMonetaryIncome = [params objectForKey:XN_MY_BUND_HOLDING_DETAIL_MODE_UNDISTRIBUTE_MONETARY_INCOME];

        return mode;
    }
    
    return nil;
    
}

@end
