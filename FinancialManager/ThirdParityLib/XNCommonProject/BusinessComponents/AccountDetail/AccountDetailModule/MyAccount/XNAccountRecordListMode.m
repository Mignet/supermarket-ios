//
//  XNAccountRecordListMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNAccountRecordListMode.h"
#import "XNAccountRecordItemMode.h"

@implementation XNAccountRecordListMode

+ (instancetype )initAccountRecordListWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNAccountRecordListMode * pd = [[XNAccountRecordListMode alloc]init];
        
        pd.pageIndex  = [params objectForKey: XN_ACCOUNT_DETAIL_LIST_PAGEINDEX];
        pd.pageSize   = [params objectForKey: XN_ACCOUNT_DETAIL_LIST_PAGESIZE];
        pd.pageCount  = [params objectForKey: XN_ACCOUNT_DETAIL_LIST_PAGECOUNT];
        pd.totalCount = [params objectForKey: XN_ACCOUNT_DETAIL_LIST_TOTALCOUNT];
        
        //计算数组
        XNAccountRecordItemMode * item = nil;
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * obj in [params objectForKey:XN_ACCOUNT_DETAIL_LIST_DATA]) {
            
            item = [XNAccountRecordItemMode initAccountRecordItemWithObject:obj];
            
            [array addObject:item];
        }
        pd.dataArray = [NSArray arrayWithArray:array];
        
        
        return pd;
    }
    return nil;
}


@end
