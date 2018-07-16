//
//  CSCustomerStatisticsMode.m
//  FinancialManager
//
//  Created by xnkj on 1/11/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNCSCustomerStatisticsMode.h"

@implementation XNCSCustomerStatisticsMode

+ (instancetype )initCustomerStaticsWithParams:(NSDictionary *)params
{
    if (params) {
        
        XNCSCustomerStatisticsMode * pd = [[XNCSCustomerStatisticsMode alloc]init];
        
        pd.regCustomer = [params objectForKey:XN_CS_CUSTOMER_REGCUSTOMER];
        pd.investCustomer = [params objectForKey:XN_CS_CUSTOMER_INVESTCUSTOMER];
        
        return pd;
    }
    
    return nil;
}
@end
