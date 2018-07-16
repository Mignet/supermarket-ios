//
//  XNUserVerifyPayPwdMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/13.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_USER_VERIFYPAYPWDSTATUS @"rlt"

@interface XNUserVerifyPayPwdMode : NSObject

@property (nonatomic, assign) BOOL result;

+ (instancetype)initUserVerifyPayPwdWithObject:(NSDictionary *)params;

@end