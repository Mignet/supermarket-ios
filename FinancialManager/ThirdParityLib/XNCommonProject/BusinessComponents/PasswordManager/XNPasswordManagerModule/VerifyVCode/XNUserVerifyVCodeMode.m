//
//  XNUserVerifyVCodeMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/12.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNUserVerifyVCodeMode.h"

@implementation XNUserVerifyVCodeMode

+ (instancetype )initVerifyVCodeWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNUserVerifyVCodeMode * pd = [[XNUserVerifyVCodeMode alloc]init];
        
        pd.resetPayPwdToken = [params objectForKey:XN_USER_VERIFYVCODE];
        
        return pd;
    }
    return nil;
}

@end
