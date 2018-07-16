//
//  XNUserVerifyPayPwdMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/13.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNUserVerifyPayPwdMode.h"

@implementation XNUserVerifyPayPwdMode

+ (instancetype)initUserVerifyPayPwdWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNUserVerifyPayPwdMode * pd = [[XNUserVerifyPayPwdMode alloc]init];
        
        pd.result = [[params objectForKey:XN_USER_VERIFYPAYPWDSTATUS] boolValue];
        
        return pd;
    }
    return nil;

}
@end
