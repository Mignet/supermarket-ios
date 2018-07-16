//
//  XNFMAgentSelectConditionMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/14/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_FM_AGENT_SELECT_CONDITION_ORGLEVEL @"orgLevel"
#define XN_FM_AGENT_SELECT_CONDITION_PROFIT @"profit"
#define XN_FM_AGENT_SELECT_CONDITION_DEADLINE @"deadline"

@interface XNFMAgentSelectConditionMode : NSObject

@property (nonatomic, strong) NSArray *orgLevel; //安全等级
@property (nonatomic, strong) NSArray *profit; //年化收益
@property (nonatomic, strong) NSArray *deadline;  //产品期限

+ (instancetype)initAgentSelectConditionWithObject:(NSDictionary *)params;

@end
