//
//  XNMyAccountDetailType.m
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNMIMyProfitTypeMode.h"

@implementation XNMIMyProfitTypeMode

+ (instancetype )initMyProfitTypeWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNMIMyProfitTypeMode * pd = [[XNMIMyProfitTypeMode alloc]init];
        
        pd.typeId = [NSString stringWithFormat:@"%@",[params objectForKey:XN_ACCOUNT_MYACCOUNT_DETAIL_TYPE_TYPEID]];
        pd.typeName = [params objectForKey:XN_ACCOUNT_MYACCOUNT_DETAIL_TYPE_TYPENAME];
        
        return pd;
    }
    return nil;
}

@end
