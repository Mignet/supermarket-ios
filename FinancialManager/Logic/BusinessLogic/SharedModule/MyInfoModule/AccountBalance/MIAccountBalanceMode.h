//
//  MIAccountBalanceMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 11/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MYINFO_ACCOUNT_BALANCE_MODE_ACCOUNT_BALANCE @"accountBalance"
#define XN_MYINFO_ACCOUNT_BALANCE_MODE_TOTAL_PROFIX @"totalProfix"
#define XN_MYINFO_ACCOUNT_BALANCE_MODE_PROFIX_LIST @"profixList"

@interface MIAccountBalanceMode : NSObject

@property (nonatomic, copy) NSString *accountBalance; //账户余额
@property (nonatomic, copy) NSString *totalProfix; //账户总收益
@property (nonatomic, strong) NSArray *profixList; //收益

+ (instancetype )initWithObject:(NSDictionary *)params;

@end
