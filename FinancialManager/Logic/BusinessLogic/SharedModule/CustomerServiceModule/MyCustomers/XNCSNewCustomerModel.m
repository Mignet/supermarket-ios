//
//  XNCSNewCustomerModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "XNCSNewCustomerModel.h"
#import "XNCSNewCustomerItemModel.h"

@implementation XNCSNewCustomerModel

+ (instancetype )initNewMyCustomerListWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNCSNewCustomerModel * pd = [[XNCSNewCustomerModel alloc] init];
        
        pd.pageIndex  = [params objectForKey: XN_CS_MYCUSTOMERLIST_PAGEINDEX];
        pd.pageSize   = [params objectForKey: XN_CS_MYCUSTOMERLIST_PAGESIZE];
        pd.pageCount  = [params objectForKey: XN_CS_MYCUSTOMERLIST_PAGECOUNT];
        pd.totalCount = [params objectForKey: XN_CS_MYCUSTOMERLIST_TOTALCOUNT];
        
        //计算数组
        XNCSNewCustomerItemModel * item = nil;
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * obj in [params objectForKey:XN_CS_MYCUSTOMERLIST_DATAS]) {
            
            item = [XNCSNewCustomerItemModel initMyNewCustomerWithObject:obj];
            
            [array addObject:item];
        }
        pd.dataArray = [NSArray arrayWithArray:array];
        
        
        return pd;
    }
    return nil;
    
}


@end
