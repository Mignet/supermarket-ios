//
//  MyAccountBookInvestListMode.m
//  FinancialManager
//
//  Created by xnkj on 19/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MyAccountBookInvestListMode.h"
#import "MyAccountBookInvestItemMode.h"

@implementation MyAccountBookInvestListMode

+ (instancetype)initAccountBookInvestListWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        MyAccountBookInvestListMode * pd = [[MyAccountBookInvestListMode alloc]init];
        
        pd.pageIndex = [params objectForKey:XN_MYINFO_INVEST_RECORD_LIST_PAGEINDEX];
        pd.pageSize = [params objectForKey:XN_MYINFO_INVEST_RECORD_LIST_PAGESIZE];
        pd.pageCount = [params objectForKey:XN_MYINFO_INVEST_RECORD_LIST_PAGECOUNT];
        pd.totalCount = [params objectForKey:XN_MYINFO_INVEST_RECORD_LIST_TOTALCOUNT];
        
        MyAccountBookInvestItemMode * mode = nil;
        NSMutableArray * arr_ = [NSMutableArray array];
        NSArray * data = [params objectForKey:XN_MYINFO_INVEST_RECORD_LIST_DATA];
        for (NSInteger index = 0 ; index < data.count; index ++ ) {
            
            mode = [MyAccountBookInvestItemMode initAccountBookInvestItemWithParams:[data objectAtIndex:index]];
            [arr_ addObject:mode];
        }
        pd.datas = arr_;
        
        return pd;
    }
    return nil;
}
@end
