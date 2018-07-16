//
//  XNMyAccountDeportRecordListMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNMyAccountDeportRecordListMode.h"
#import "XNMyAccountWithDrawRecordItemMode.h"

@implementation XNMyAccountDeportRecordListMode

+ (instancetype )initMyAccountRecordListWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNMyAccountDeportRecordListMode * pd = [[XNMyAccountDeportRecordListMode alloc]init];
        
        pd.pageIndex  = [params objectForKey: XN_ACCOUNT_MYACCOUNT_RECORD_LIST_PAGEINDEX];
        pd.pageSize   = [params objectForKey: XN_ACCOUNT_MYACCOUNT_RECORD_LIST_PAGESIZE];
        pd.pageCount  = [params objectForKey: XN_ACCOUNT_MYACCOUNT_RECORD_LIST_PAGECOUNT];
        pd.totalCount = [params objectForKey: XN_ACCOUNT_MYACCOUNT_RECORD_LIST_TOTALCOUNT];
        
        //计算数组
        XNMyAccountWithDrawRecordItemMode * item = nil;
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * obj in [params objectForKey:XN_ACCOUNT_MYACCOUNT_RECORD_LIST_DATA]) {
            
            item = [XNMyAccountWithDrawRecordItemMode initWithDrawRecordItemWithObject:obj];
            
            [array addObject:item];
        }
        pd.dataArray = [NSArray arrayWithArray:array];
        
        
        return pd;
    }
    return nil;
}

@end
