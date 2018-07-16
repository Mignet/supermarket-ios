//
//  XNInvestPlatformDetailMode.m
//  FinancialManager
//
//  Created by xnkj on 29/06/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNInvestPlatformDetailMode.h"

@implementation XNInvestPlatformDetailMode

+ (instancetype)initInvestPlatformDetailWithParams:(NSDictionary *)params
{
    if (params) {
        
        XNInvestPlatformDetailMode * pd = [[XNInvestPlatformDetailMode alloc]init];
        
        pd.investingAmt = [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_INVESTAMT];
        pd.investingProfit = [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_INVESTPROFIT];
        pd.platformLogo = [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_PLATFORMLOGO];
        pd.orgAccount = [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_ORGACCOUNT];
        pd.orgKey = [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_ORGKEY];
        pd.orgNumber = [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_ORGNUMBER];
        pd.orgUsercenterUrl = [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_ORGUSERCENTERURL];
        pd.requestFrom = [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_REQUESTFORM];
        pd.sign = [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_SIGN];
        pd.timestamp = [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_TIMESTAMP];
        pd.platformName = [params objectForKey:XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_NAME];
        
        return pd;
    }
    
    return nil;
}
@end
