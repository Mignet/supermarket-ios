//
//  XNMIMyProfitListMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNMIMyProfitDetailListMode.h"

@implementation XNMIMyProfitDetailListMode

+ (instancetype )initMyProfitDetailListWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNMIMyProfitDetailListMode * pd = [[XNMIMyProfitDetailListMode alloc]init];
        
        pd.pageIndex  = [params objectForKey: XN_MYINFO_MYPROFIT_DETAIL_LIST_PAGEINDEX];
        pd.pageSize   = [params objectForKey: XN_MYINFO_MYPROFIT_DETAIL_LIST_PAGESIZE];
        pd.pageCount  = [params objectForKey: XN_MYINFO_MYPROFIT_DETAIL_LIST_PAGECOUNT];
        pd.totalCount = [params objectForKey: XN_MYINFO_MYPROFIT_DETAIL_LIST_TOTALCOUNT];
        pd.dataArray = [params objectForKey:XN_MYINFO_MYPROFIT_DETAIL_LIST_DATA];
        
        return pd;

    }
    
    return nil;
}

@end
