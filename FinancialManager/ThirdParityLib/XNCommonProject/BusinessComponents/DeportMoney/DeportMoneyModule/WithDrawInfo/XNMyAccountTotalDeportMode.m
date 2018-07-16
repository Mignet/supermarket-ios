//
//  XNMyAccountTotalDeportMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNMyAccountTotalDeportMode.h"

@implementation XNMyAccountTotalDeportMode

+ (instancetype )initTotalDeportWithObject:(NSDictionary *)params
{
    if([NSObject isValidateObj:params])
    {
        XNMyAccountTotalDeportMode * pd = [[XNMyAccountTotalDeportMode alloc]init];
        
        pd.outTotalAmount = [params objectForKey:XN_ACCOUNT_MYACCOUNT_DEPORT_OUTTOTALAMOUNT];
        pd.outingAmount = [params objectForKey:XN_ACCOUNT_MYACCOUNT_DEPORT_OUTINGAMOUNT];
        pd.outingFee = [params objectForKey:XN_ACCOUNT_MYACCOUNT_DEPORT_OUTINGFEE];
        pd.outTotalFee = [params objectForKey:XN_ACCOUNT_MYACCOUNT_DEPORT_OUTTOTALLFEE];
        
        return pd;
    }
    return nil;
}
@end
