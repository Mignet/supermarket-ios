//
//  ReturnMoneyListModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/19.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "ReturnMoneyListModel.h"
#import "ReturnMoneyItemModel.h"

@implementation ReturnMoneyListModel

+ (instancetype )initReturnMoneyItemWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        ReturnMoneyListModel * pd = [[ReturnMoneyListModel alloc]init];
        
        pd.pageIndex  = [params objectForKey: XN_CS_TRADELIST_PAGEINDEX];
        pd.pageSize   = [params objectForKey: XN_CS_TRADELIST_PAGESIZE];
        pd.pageCount  = [params objectForKey: XN_CS_TRADELIST_PAGECOUNT];
        pd.totalCount = [params objectForKey: XN_CS_TRADELIST_TOTALCOUNT];
        
        //计算数组
        ReturnMoneyItemModel * item = nil;
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * obj in [params objectForKey:XN_CS_TRADELIST_DATA]) {
            
            item = [ReturnMoneyItemModel initeturnMoneyItemWithObject:obj];
            
            [array addObject:item];
        }
        pd.dataArray = [NSArray arrayWithArray:array];
        
        
        return pd;
    }
    return nil;}


@end
