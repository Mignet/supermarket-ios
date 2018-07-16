//
//  MIAccountBalanceProfixItemMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 11/24/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_ACCOUNT_BALANCE_PROFIX_ITEM_MODE_GRANT_DESC @"grantDesc"
#define XN_ACCOUNT_BALANCE_PROFIX_ITEM_MODE_MONTH @"month"
#define XN_ACCOUNT_BALANCE_PROFIX_ITEM_MODE_MONTH_DESC @"monthDesc"
#define XN_ACCOUNT_BALANCE_PROFIX_ITEM_MODE_TOTAL_AMOUNT @"totalAmount"

@interface MIAccountBalanceProfixItemMode : NSObject

@property (nonatomic, copy) NSString *grantDesc; //发放描述；例：下月15号发放
@property (nonatomic, copy) NSString *month; //月份；例：2016-11
@property (nonatomic, copy) NSString *monthDesc; //月份描述；例：本月收益
@property (nonatomic, copy) NSString *totalAmount; //总计

+ (instancetype )initWithObject:(NSDictionary *)params;

@end
