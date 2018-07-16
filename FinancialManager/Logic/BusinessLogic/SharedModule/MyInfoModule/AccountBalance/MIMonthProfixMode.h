//
//  MIMonthProfixMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 11/24/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MONTH_PROFIX_MODE_GRANTED_AMOUNT @"grantedAmount"
#define XN_MONTH_PROFIX_MODE_WAIT_GRANT_AMOUNT @"waitGrantAmount"
#define XN_MONTH_PROFIX_MODE_GRANT_TOTAL_PROFIX @"totalProfix"
#define XN_MONTH_PROFIX_MODE_GRANT_PROFIX_LIST @"profixList"

@interface MIMonthProfixMode : NSObject

@property (nonatomic, copy) NSString *grantedAmount; //已发放金额
@property (nonatomic, copy) NSString *waitGrantAmount; //待发放金额
@property (nonatomic, copy) NSString *totalProfix; //总收益
@property (nonatomic, strong) NSArray *profixList; //收益

+ (instancetype )initWithObject:(NSDictionary *)params;

@end
