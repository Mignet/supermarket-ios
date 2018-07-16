//
//  ReturnMoneyItemModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/19.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "ReturnMoneyItemModel.h"

@implementation ReturnMoneyItemModel

+ (instancetype )initeturnMoneyItemWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        ReturnMoneyItemModel * pd = [[ReturnMoneyItemModel alloc]init];
        
        pd.endTime = [params objectForKey:XN_CS_RETURN_MONEY_ENDTIME];
        pd.endTimeStr = [params objectForKey:XN_CS_RETURN_MONEY_ENDTIMESTR];
        pd.headImage = [params objectForKey:XN_CS_RETURN_MONEY_HEADIMAGE];
        pd.investAmt = [params objectForKey:XN_CS_RETURN_MONEY_INVESTAMT];
        pd.investId = [params objectForKey:XN_CS_RETURN_MONEY_INVESTID];
        pd.orderType = [params objectForKey:XN_CS_RETURN_MONEY_ORDERTYPE];
        pd.platformName = [params objectForKey:XN_CS_RETURN_MONEY_PLATFORMNAME];
        pd.profit = [params objectForKey:XN_CS_RETURN_MONEY_PROFIT];
        pd.repaymentUserType = [params objectForKey:XN_CS_RETURN_MONEY_REPAYMENTUSERTYPE];
        pd.userName = [params objectForKey:XN_CS_RETURN_MONEY_USERNAME];
                
        return pd;
    }
    
    return nil;

}

@end
