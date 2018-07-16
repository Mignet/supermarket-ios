//
//  XNLoginMode.h
//  FinancialManager
//
//  Created by xnkj on 15/9/25.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_USERMODULE_LOGIN_TOKEN @"token"

@interface XNLoginMode : NSObject

@property (nonatomic, strong) NSString * token;

+ (instancetype)initWithParams:(NSDictionary *)params;
@end
