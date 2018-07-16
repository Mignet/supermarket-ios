//
//  XNGetUserBindBankCardInfoMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/20.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNGetUserBindBankCardInfoMode.h"

@implementation XNGetUserBindBankCardInfoMode

+ (instancetype )initUserBindBankCardInfoWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNGetUserBindBankCardInfoMode * pd = [[XNGetUserBindBankCardInfoMode alloc]init];
        
        pd.bankCard = [params objectForKey:XN_ACCOUNT_USERBINDBANKCARD_BANKCARD];
        pd.bankName = [params objectForKey:XN_ACCOUNT_USERBINDBANKCARD_BANK_NAME];
        pd.idCard = [params objectForKey:XN_ACCOUNT_USERBINDBANKCARD_USER_NUMBER];
        pd.userName = [params objectForKey:XN_ACCOUNT_USERBINDBANKCARD_USER_NAME];
        pd.userPhoneNumber = [params objectForKey:XN_ACCOUNT_USER_PHONE_NUMBER];
        
        return pd;
    }
    return nil;
}

@end
