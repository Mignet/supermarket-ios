//
//  MyAccountBookinvestitemMode.m
//  FinancialManager
//
//  Created by xnkj on 19/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyAccountBookInvestItemMode.h"

@implementation MyAccountBookInvestItemMode

+ (instancetype)initAccountBookInvestItemWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        MyAccountBookInvestItemMode * pd = [[MyAccountBookInvestItemMode alloc]init];
        
        pd.investId = [NSString stringWithFormat:@"%@",[params objectForKey:XN_ACCOUNTBOOK_INVEST_ITEM_INVESTID]];
        pd.investAmt = [NSString stringWithFormat:@"%@",[params objectForKey:XN_ACCOUNTBOOK_INVEST_ITEM_INVESTAMT]];
        pd.direction = [params objectForKey:XN_ACCOUNTBOOK_INVEST_ITEM_INVESTDIRECTION];
        pd.investProfit = [NSString stringWithFormat:@"%@",[params objectForKey:XN_ACCOUNTBOOK_INVEST_ITEM_PROFIT]];
        pd.remark = [params objectForKey:XN_ACCOUNTBOOK_INVEST_ITEM_REMARK];
        pd.status = [[params objectForKey:XN_ACCOUNTBOOK_INVEST_ITEM_STATUS] boolValue];
        pd.createTime = [params objectForKey:XN_ACCOUNTBOOK_INVEST_ITEM_CREATETIME];
        
        return pd;
    }
    return nil;
}
@end
