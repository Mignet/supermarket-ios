//
//  XNCSCustomerCfpMemberMode.m
//  FinancialManager
//
//  Created by xnkj on 17/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNCSCustomerCfpMemberMode.h"

@implementation XNCSCustomerCfpMemberMode

+ (instancetype)initCustomerCfgMemberWithParams:(NSDictionary *)parmas
{
    if ([NSObject isValidateObj:parmas]) {
        
        XNCSCustomerCfpMemberMode * pd = [[XNCSCustomerCfpMemberMode alloc]init];
        
        pd.directRecomNum = [parmas objectForKey:XN_CUSTOMERSERVER_DIRECTRECOMNUM];
        pd.myAttention = [parmas objectForKey:XN_CUSTOMERSERVER_MYATTENTION];
        pd.myCustomerNum = [parmas objectForKey:XN_CUSTOMERSERVER_MYCUSTOMERNUM];
        pd.noInvest = [parmas objectForKey:XN_CUSTOMERSERVER_NOINVEST];
        pd.secondLevelNum = [parmas objectForKey:XN_CUSTOMERSERVER_SECONDLEVELNUM];
        pd.threeLevelNum = [parmas objectForKey:XN_CUSTOMERSERVER_THREELEVELNUM];
        
        return pd;
    }
    return nil;
}

@end
