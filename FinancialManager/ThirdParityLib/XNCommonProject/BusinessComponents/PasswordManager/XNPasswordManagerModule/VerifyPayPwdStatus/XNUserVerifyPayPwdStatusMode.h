//
//  XNUserVerifyPayPwdStatusMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/12.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_USER_VERIFYPAYPWDSTATUS @"rlt"

@interface XNUserVerifyPayPwdStatusMode : NSObject

@property (nonatomic, assign) BOOL result;

+ (instancetype)initUserVerifyPayPwdStatusWithObject:(NSDictionary *)params;
@end
