//
//  MyAccountBookDetailMode.m
//  FinancialManager
//
//  Created by xnkj on 19/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyAccountBookDetailMode.h"

@implementation MyAccountBookDetailMode

+ (instancetype)initAccountBookDetailWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        MyAccountBookDetailMode * pd = [[MyAccountBookDetailMode alloc]init];
        
        pd.investTotal = [params objectForKey:XN_MYACCOUNTBOOK_DETAIL_INVESTOTAL];
        pd.investProfit = [params objectForKey:XN_MYACCOUNTBOOK_DETAIL_INVESTTOTALPROFIT];
        pd.investAmount = [params objectForKey:XN_MYACCOUNTBOOK_DETAIL_INVESTTOTALAMT];
        
        return pd;
    }
    return nil;
}
@end
