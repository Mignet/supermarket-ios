//
//  XNHomeCommissionMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 6/22/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNHomeCommissionMode.h"

@implementation XNHomeCommissionMode

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNHomeCommissionMode *mode = [[XNHomeCommissionMode alloc] init];
        mode.commissionAmount = [params objectForKey:XN_HOMEPAGE_COMMISSION_AMOUNT];
        mode.orderListDesc = [params objectForKey:XN_HOMEPAGE_ORDER_LIST_DESC];
        mode.newcomerTaskStatus = [[params objectForKey:XN_HOMEPAGE_NEWCOMMER_TASKSTATUS] integerValue];
        
        return mode;
    }
    return nil;
}

@end
