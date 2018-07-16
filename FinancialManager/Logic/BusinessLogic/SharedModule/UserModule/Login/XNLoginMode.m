//
//  XNLoginMode.m
//  FinancialManager
//
//  Created by xnkj on 15/9/25.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNLoginMode.h"

@implementation XNLoginMode

+ (instancetype)initWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNLoginMode * pd = [[XNLoginMode alloc]init];
        
        pd.token = [params objectForKey:XN_USERMODULE_LOGIN_TOKEN];
        
        return pd;
    }
    
    return nil;
}

@end
