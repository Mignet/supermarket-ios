//
//  XNHomeCommissionMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 6/22/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_HOMEPAGE_COMMISSION_AMOUNT @"commissionAmount"
#define XN_HOMEPAGE_ORDER_LIST_DESC @"orderList"
#define XN_HOMEPAGE_NEWCOMMER_TASKSTATUS @"newcomerTaskStatus"

@interface XNHomeCommissionMode : NSObject

@property (nonatomic, copy) NSString *commissionAmount; //累计发放佣金
@property (nonatomic, strong) NSArray *orderListDesc; //出单描述
@property (nonatomic, assign) NSInteger newcomerTaskStatus;//新手任务状态

+ (instancetype )initWithObject:(NSDictionary *)params;

@end
