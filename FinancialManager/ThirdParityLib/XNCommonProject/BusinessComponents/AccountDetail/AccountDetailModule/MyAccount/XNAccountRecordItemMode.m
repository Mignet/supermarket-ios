//
//  XNAccountRecordItemMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNAccountRecordItemMode.h"

@implementation XNAccountRecordItemMode

+ (instancetype )initAccountRecordItemWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNAccountRecordItemMode * pd = [[XNAccountRecordItemMode alloc]init];
        
        pd.typeName = [params objectForKey:XN_ACCOUNT_RECORD_ITEM_TYPENAME];
        pd.time = [params objectForKey:XN_ACCOUNT_RECORD_ITEM_TIME];
        pd.amount = [params objectForKey:XN_ACCOUNT_RECORD_ITEM_AMOUNT];
        pd.profitFee = [params objectForKey:XN_ACCOUNT_RECORD_ITEM_FEE];
        pd.content = [params objectForKey:XN_ACCOUNT_RECORD_ITEM_CONTENT];
        
        return pd;
    }
    return nil;
}

@end
