//
//  XNGetBankCardInfoMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/17.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNBankCardMode.h"


@implementation XNBankCardMode

+ (instancetype )initBankCardModeWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNBankCardMode * pd = [[XNBankCardMode alloc]init];
        
        pd.remark = [params objectForKey:XN_ACCOUNT_BANKCARD_BANK_CODE];
        pd.haveBind = [params objectForKey:XN_ACCOUNT_BANKCARD_BANK_HAVEBIND];
        
        return pd;
    }
    return nil;
}
@end
