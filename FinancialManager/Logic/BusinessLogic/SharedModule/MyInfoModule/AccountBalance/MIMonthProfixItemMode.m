//
//  MIMonthProfixItemMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/24/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIMonthProfixItemMode.h"

@implementation MIMonthProfixItemMode

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        MIMonthProfixItemMode *mode = [[MIMonthProfixItemMode alloc] init];
        mode.amount = [params objectForKey:XN_MONTH_PROFIX_ITEM_MODE_AMOUNT];
        mode.deadline = [params objectForKey:XN_MONTH_PROFIX_ITEM_MODE_DEADLINE];
        mode.desc = [params objectForKey:XN_MONTH_PROFIX_ITEM_MODE_DESC];
        mode.feeRate = [params objectForKey:XN_MONTH_PROFIX_ITEM_MODE_FEERATE];
        mode.profixType = [params objectForKey:XN_MONTH_PROFIX_ITEM_MODE_PROFIX_TYPE];
        mode.profixTypeName = [params objectForKey:XN_MONTH_PROFIX_ITEM_MODE_PROFIX_TYPE_NAME];
        mode.time = [params objectForKey:XN_MONTH_PROFIX_ITEM_MODE_TIME];
        mode.remark = [params objectForKey:XN_MONTH_PROFIX_ITEM_MODE_REMARK];
        mode.productType = [params objectForKey:XN_MONTH_PROFIX_ITEM_MODE_PRODUCT_TYPE];
        mode.productTypeDesc = [params objectForKey:XN_MONTH_PROFIX_ITEM_MODE_PRODUCT_TYPE_DESC];
        return mode;
    }
    return nil;
}

@end
