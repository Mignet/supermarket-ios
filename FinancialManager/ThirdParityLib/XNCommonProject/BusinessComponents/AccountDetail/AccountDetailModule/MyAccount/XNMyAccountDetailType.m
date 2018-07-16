//
//  XNMyAccountDetailType.m
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNMyAccountDetailType.h"

@implementation XNMyAccountDetailType

+ (instancetype )initMyAccountDetailTypeWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNMyAccountDetailType * pd = [[XNMyAccountDetailType alloc]init];
        
        pd.typeId = [params objectForKey:XN_ACCOUNT_MYACCOUNT_DETAIL_TYPE_TYPEID];
        pd.typeName = [params objectForKey:XN_ACCOUNT_MYACCOUNT_DETAIL_TYPE_TYPENAME];
        
        return pd;
    }
    return nil;
}

@end
