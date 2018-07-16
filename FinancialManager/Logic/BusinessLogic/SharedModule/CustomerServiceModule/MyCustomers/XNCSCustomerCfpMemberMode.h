//
//  XNCSCustomerCfpMemberMode.h
//  FinancialManager
//
//  Created by xnkj on 17/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_CUSTOMERSERVER_DIRECTRECOMNUM @"directRecomNum"
#define XN_CUSTOMERSERVER_MYATTENTION @"myAttention"
#define XN_CUSTOMERSERVER_MYCUSTOMERNUM @"myCustomerNum"
#define XN_CUSTOMERSERVER_NOINVEST @"noInvest"
#define XN_CUSTOMERSERVER_SECONDLEVELNUM @"secondLevelNum"
#define XN_CUSTOMERSERVER_THREELEVELNUM @"threeLevelNum"

@interface XNCSCustomerCfpMemberMode : NSObject

@property (nonatomic, strong) NSString * directRecomNum;
@property (nonatomic, strong) NSString * myAttention;
@property (nonatomic, strong) NSString * myCustomerNum;
@property (nonatomic, strong) NSString * noInvest;
@property (nonatomic, strong) NSString * secondLevelNum;
@property (nonatomic, strong) NSString * threeLevelNum;

+ (instancetype)initCustomerCfgMemberWithParams:(NSDictionary *)parmas;
@end
