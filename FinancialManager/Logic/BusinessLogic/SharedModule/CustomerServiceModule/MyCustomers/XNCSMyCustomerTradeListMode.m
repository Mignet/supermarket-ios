//
//  XNCSMyCustomerTradeListMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/21.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNCSMyCustomerTradeListMode.h"
#import "XNCSMyCustomerTradeItemMode.h"

@implementation XNCSMyCustomerTradeListMode

+ (instancetype )initMyCustomerTradeListWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNCSMyCustomerTradeListMode * pd = [[XNCSMyCustomerTradeListMode alloc]init];
        
        pd.pageIndex  = [params objectForKey: XN_CS_MYCUSTOMERLIST_PAGEINDEX];
        pd.pageSize   = [params objectForKey: XN_CS_MYCUSTOMERLIST_PAGESIZE];
        pd.pageCount  = [params objectForKey: XN_CS_MYCUSTOMERLIST_PAGECOUNT];
        pd.totalCount = [params objectForKey: XN_CS_MYCUSTOMERLIST_TOTALCOUNT];
        
        //计算数组
        XNCSMyCustomerTradeItemMode * item = nil;
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * obj in [params objectForKey:XN_CS_MYCUSTOMERLIST_DATA]) {
            
            item = [XNCSMyCustomerTradeItemMode initMyCustomerTradeItemWithObject:obj];
            
            [array addObject:item];
        }
        pd.dataArray = [NSArray arrayWithArray:array];
        
        
        return pd;
    }
    return nil;
}

@end
