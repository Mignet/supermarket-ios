//
//  XNUserVerifyVCodeMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/12.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_USER_VERIFYVCODE     @"resetPayPwdToken"

@interface XNUserVerifyVCodeMode : NSObject

@property (nonatomic, strong) NSString * resetPayPwdToken;

+ (instancetype )initVerifyVCodeWithObject:(NSDictionary *)params;
@end
