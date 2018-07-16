//
//  XNUserVerifyPayPwdStatusMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/12.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNUserVerifyPayPwdStatusMode.h"

@implementation XNUserVerifyPayPwdStatusMode

+ (instancetype)initUserVerifyPayPwdStatusWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNUserVerifyPayPwdStatusMode * pd = [[XNUserVerifyPayPwdStatusMode alloc]init];
        
        pd.result = [[params objectForKey:XN_USER_VERIFYPAYPWDSTATUS] boolValue];
        
        return pd;
    }
    return nil;
}
@end
