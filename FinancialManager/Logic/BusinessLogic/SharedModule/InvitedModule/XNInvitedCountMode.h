//
//  XNInvitedCountMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 6/27/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#define XN_INVITED_COUNT_MODE_CFGNUM @"cfpNum"
#define XN_INVITED_COUNT_MODE_INVESTORNUM @"investorNum"

#import <Foundation/Foundation.h>

@interface XNInvitedCountMode : NSObject

@property (nonatomic, strong) NSNumber *cfpNum; //推荐理财师数量
@property (nonatomic, strong) NSNumber *investorNum; //邀请客户数量

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
