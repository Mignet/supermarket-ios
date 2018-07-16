//
//  RankCalcBaseDataMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 5/23/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RANK_CALC_BASE_DATA_LIST_MODE_CFG_LEVEL_LIST @"crmCfpLevelList"
#define RANK_CALC_BASE_DATA_LIST_MODE_FEE_TYPE_LIST @"feeTypeList"

@interface RankCalcBaseDataListMode : NSObject

@property (nonatomic, strong) NSArray *crmCfgLevelList; //	理财师职级信息
@property (nonatomic, strong) NSArray *feeTypeList; //理财师佣金信息

+ (instancetype)initWithParams:(NSDictionary *)params;

@end
