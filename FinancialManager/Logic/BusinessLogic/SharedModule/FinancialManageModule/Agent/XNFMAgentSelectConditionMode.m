//
//  XNFMAgentSelectConditionMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/14/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNFMAgentSelectConditionMode.h"

@implementation XNFMAgentSelectConditionMode

+ (instancetype)initAgentSelectConditionWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNFMAgentSelectConditionMode *mode = [[XNFMAgentSelectConditionMode alloc] init];
        mode.orgLevel = [params objectForKey:XN_FM_AGENT_SELECT_CONDITION_ORGLEVEL];
        mode.profit = [params objectForKey:XN_FM_AGENT_SELECT_CONDITION_PROFIT];
        mode.deadline = [params objectForKey:XN_FM_AGENT_SELECT_CONDITION_DEADLINE];
        
        return mode;
    }
    return nil;
}

@end
