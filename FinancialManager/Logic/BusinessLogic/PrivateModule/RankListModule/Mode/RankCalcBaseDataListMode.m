//
//  RankCalcBaseDataMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 5/23/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "RankCalcBaseDataListMode.h"
#import "RankCalcLevelMode.h"

@implementation RankCalcBaseDataListMode

+ (instancetype)initWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        RankCalcBaseDataListMode *listMode = [[RankCalcBaseDataListMode alloc] init];

        NSMutableArray *levelArray = [NSMutableArray array];
        RankCalcLevelMode *mode = nil;
        for (NSDictionary *dic in [params objectForKey:RANK_CALC_BASE_DATA_LIST_MODE_CFG_LEVEL_LIST])
        {
            mode = [RankCalcLevelMode initWithParams:dic];
            [levelArray addObject:mode];
        }
        listMode.crmCfgLevelList = levelArray;
        
        listMode.feeTypeList = [params objectForKey:RANK_CALC_BASE_DATA_LIST_MODE_FEE_TYPE_LIST];
        return listMode;
    }
    
    return nil;
}

@end
