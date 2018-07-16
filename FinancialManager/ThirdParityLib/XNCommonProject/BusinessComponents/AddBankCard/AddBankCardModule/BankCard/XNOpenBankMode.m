//
//  XNGetBankCardInfoMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/17.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNOpenBankMode.h"


@implementation XNOpenBankMode

+ (instancetype )initOpenBankModeWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNOpenBankMode * pd = [[XNOpenBankMode alloc]init];
        
        pd.bankCode = [params objectForKey:XN_ACCOUNT_BANKCARD_BANK_CODE];
        pd.bankName = [params objectForKey:XN_ACCOUNT_BANKCARD_BANK_NAME];
        pd.bankId = [NSString stringWithFormat:@"%@",[params objectForKey:XN_ACCOUNT_BANKCARD_BANK_ID]];
        pd.createTime = [params  objectForKey:XN_ACCOUNT_BANKCARD_CREATETIME];
        pd.dayLimitAccount = [NSString stringWithFormat:@"%@",[params objectForKey:XN_ACCOUNT_BANKCARD_DAYLIMITAMOUNT]];
        pd.lastUpdateTime = [params objectForKey:XN_ACCOUNT_BANKCARD_LASTUPDATETIME];
        pd.monthLimitAmount = [NSString stringWithFormat:@"%@",[params objectForKey:XN_ACCOUNT_BANKCARD_MONTHLIMITAMOUNT]];
        pd.providerName = [params objectForKey:XN_ACCOUNT_BANKCARD_PROVIDERNAME];
        pd.recordLimitAmount = [NSString stringWithFormat:@"%@",[params objectForKey:XN_ACCOUNT_BANKCARD_RECORDLIMITAMOUNT]];
        pd.remark = [params objectForKey:XN_ACCOUNT_BANKCARD_REMARK];
        pd.status = [NSString stringWithFormat:@"%@",[params objectForKey:XN_ACCOUNT_BANKCARD_STATUS]];
        pd.bankServicePhone = [params objectForKey:XN_ACCOUNT_BANKCARD_SERVERPHONE];
        
        return pd;
    }
    return nil;
}
@end
