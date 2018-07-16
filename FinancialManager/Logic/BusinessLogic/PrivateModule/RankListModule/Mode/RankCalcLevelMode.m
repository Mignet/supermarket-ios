//
//  RankCalcLevelMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 5/24/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "RankCalcLevelMode.h"

@implementation RankCalcLevelMode

+ (instancetype)initWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        RankCalcLevelMode *mode = [[RankCalcLevelMode alloc] init];
        mode.createTime = [params objectForKey:RANK_CALC_LEVEL_MODE_CREATE_TIME];
        mode.levelCode = [params objectForKey:RANK_CALC_LEVEL_MODE_LEVEL_CODE];
        mode.levelName = [params objectForKey:RANK_CALC_LEVEL_MODE_LEVEL_NAME];
        mode.levelRemark = [params objectForKey:RANK_CALC_LEVEL_MODE_LEVEL_REMARK];
        mode.levelWeight = [[params objectForKey:RANK_CALC_LEVEL_MODE_LEVEL_WEIGHT] integerValue];
        return mode;
    }
    
    return nil;
}

@end
