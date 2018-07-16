//
//  XNMyAccountInfoMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNMyAccountInfoMode.h"

@implementation XNMyAccountInfoMode

+ (instancetype )initMyAccountWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
     
        XNMyAccountInfoMode * pd = [[XNMyAccountInfoMode alloc]init];
        
        pd.accountBalance = [params objectForKey:XN_ACCOUNT_MYACCOUNT_ACCOUNTBALANCE];
        
        return pd;
    }
    return nil;
}
@end
