//
//  XNMyAccountInfoMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_ACCOUNT_MYACCOUNT_ACCOUNTBALANCE @"totalAmount"

@interface XNMyAccountInfoMode : NSObject

@property (nonatomic, strong) NSString * accountBalance;

+ (instancetype )initMyAccountWithObject:(NSDictionary *)params;
@end
