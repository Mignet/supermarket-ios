//
//  XNInvitedCountMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 6/27/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNInvitedCountMode.h"

@implementation XNInvitedCountMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNInvitedCountMode * pd = [[XNInvitedCountMode alloc] init];
        pd.cfpNum = [params objectForKey:XN_INVITED_COUNT_MODE_CFGNUM];
        pd.investorNum = [params objectForKey:XN_INVITED_COUNT_MODE_INVESTORNUM];
        
        return pd;
    }
    return nil;
}

@end
