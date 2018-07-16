//
//  MIAccountBalanceCommonMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/24/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "MIAccountBalanceCommonMode.h"
#import "MIAccountBalanceProfixItemMode.h"
#import "MIMonthProfixItemMode.h"
#import "MIAccountBalanceDetailItemMode.h"

@implementation MIAccountBalanceCommonMode

#pragma mark - 账户余额月份收益列表
+ (instancetype )initWithAccountBalanceMonthProfixObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        MIAccountBalanceCommonMode *mode = [[MIAccountBalanceCommonMode alloc] init];
        mode.pageCount = [[params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_PAGE_COUNT] integerValue];
        mode.pageIndex = [[params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_PAGE_INDEX] integerValue];
        mode.pageSize = [[params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_PAGE_SIZE] integerValue];
        mode.totalCount = [[params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_TOTAL_COUNT] integerValue];
        
        NSMutableArray *array = [NSMutableArray array];
        MIAccountBalanceProfixItemMode *itemMode = nil;
        for (NSDictionary *dic in [params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_DATAS])
        {
            itemMode = [MIAccountBalanceProfixItemMode initWithObject:dic];
            [array addObject:itemMode];
        }
        mode.datas = array;
        return mode;
    }
    return nil;
}

#pragma mark -月度收益明细列表
+ (instancetype )initWithMonthProfixListObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        MIAccountBalanceCommonMode *mode = [[MIAccountBalanceCommonMode alloc] init];
        mode.pageCount = [[params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_PAGE_COUNT] integerValue];
        mode.pageIndex = [[params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_PAGE_INDEX] integerValue];
        mode.pageSize = [[params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_PAGE_SIZE] integerValue];
        mode.totalCount = [[params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_TOTAL_COUNT] integerValue];
        NSMutableArray *array = [NSMutableArray array];
        MIMonthProfixItemMode *itemMode = nil;
        for (NSDictionary *dic in [params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_DATAS])
        {
            itemMode = [MIMonthProfixItemMode initWithObject:dic];
            [array addObject:itemMode];
        }
        mode.datas = array;
        return mode;
    }
    return nil;
}

//资金明细
+ (instancetype)initWithAccountBalanceDetailListObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        MIAccountBalanceCommonMode *mode = [[MIAccountBalanceCommonMode alloc] init];
        mode.pageCount = [[params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_PAGE_COUNT] integerValue];
        mode.pageIndex = [[params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_PAGE_INDEX] integerValue];
        mode.pageSize = [[params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_PAGE_SIZE] integerValue];
        mode.totalCount = [[params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_TOTAL_COUNT] integerValue];
        NSMutableArray *array = [NSMutableArray array];
        
        MIAccountBalanceDetailItemMode *itemMode = nil;
        for (NSDictionary *dic in [params objectForKey:XN_ACCOUNT_BALANCE_COMMON_MODE_DATAS])
        {
            itemMode = [MIAccountBalanceDetailItemMode initWithObject:dic];
            [array addObject:itemMode];
        }
        mode.datas = array;
        return mode;
    }
    return nil;
}

@end
