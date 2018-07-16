//
//  MIAccountBalanceDetailMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 2/14/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_ACCOUNT_BALANCE_DETAIL_MODE_ACCOUNT_BALANCE @"accountBalance"
#define XN_ACCOUNT_BALANCE_DETAIL_MODE_INCOME_SUMMARY @"incomeSummary"
#define XN_ACCOUNT_BALANCE_DETAIL_MODE_OUT_SUMMARY @"outSummary"

@interface MIAccountBalanceDetailMode : NSObject

@property (nonatomic, copy) NSString *accountBalance; //账户余额
@property (nonatomic, copy) NSString *incomeSummary; //累计收入
@property (nonatomic, copy) NSString *outSummary; //累计支出

+ (instancetype )initWithObject:(NSDictionary *)params;

@end
