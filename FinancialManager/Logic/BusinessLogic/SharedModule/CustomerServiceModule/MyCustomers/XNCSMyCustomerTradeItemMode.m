//
//  XNCSMyCustomerTradeItemMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/21.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNCSMyCustomerTradeItemMode.h"

@implementation XNCSMyCustomerTradeItemMode

+ (instancetype )initMyCustomerTradeItemWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNCSMyCustomerTradeItemMode * pd = [[XNCSMyCustomerTradeItemMode alloc]init];
        
        pd.time = [params objectForKey:XN_CS_MYCUSTOMER_TRADE_ITEM_TIME];
        pd.tradeType = [params objectForKey:XN_CS_MYCUSTOMER_TRADE_ITEM_TRADETYPE];
        pd.amount = [params objectForKey:XN_CS_MYCUSTOMER_TRADE_ITEM_AMOUNT];
        pd.productName = [params objectForKey:XN_CS_MYCUSTOMER_TRADE_ITEM_PRODUCTNAME];
        pd.yearRate = [params objectForKey:XN_CS_MYCUSTOMER_TRADE_ITEM_YEARRATE];
        pd.feeRate = [params objectForKey:XN_CS_MYCUSTOMER_TRADE_ITEM_FEERATE];
        pd.startDate = [params objectForKey:XN_CS_MYCUSTOMER_TRADE_ITEM_STARTDATE];
        pd.endDate = [params objectForKey:XN_CS_MYCUSTOMER_TRADE_ITEM_ENDDATE];
        pd.profit = [params objectForKey:XN_CS_MYCUSTOMER_TRADE_ITEM_PROFIT];
        pd.feeProfit = [params objectForKey:XN_CS_MYCUSTOMER_TRADE_ITEM_FEEPROFIT];
        
        return pd;
    }
    return nil;
}

@end
