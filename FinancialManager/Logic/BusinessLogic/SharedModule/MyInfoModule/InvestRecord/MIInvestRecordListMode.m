//
//  MIInvestRecordListMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 6/26/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MIInvestRecordListMode.h"
#import "MIInvestRecordItemMode.h"

@implementation MIInvestRecordListMode

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        MIInvestRecordListMode *pd = [[MIInvestRecordListMode alloc]init];
        
        pd.pageIndex = [params objectForKey:XN_MYINFO_INVEST_RECORD_LIST_PAGEINDEX];
        pd.pageSize = [params objectForKey:XN_MYINFO_INVEST_RECORD_LIST_PAGESIZE];
        pd.pageCount = [params objectForKey:XN_MYINFO_INVEST_RECORD_LIST_PAGECOUNT];
        pd.totalCount = [params objectForKey:XN_MYINFO_INVEST_RECORD_LIST_TOTALCOUNT];
        
        MIInvestRecordItemMode * mode = nil;
        NSMutableArray * redPacketArray = [NSMutableArray array];
        NSArray * data = [params objectForKey:XN_MYINFO_INVEST_RECORD_LIST_DATA];
        for (NSInteger index = 0 ; index < data.count; index ++ ) {
            
            mode = [MIInvestRecordItemMode initWithObject:[data objectAtIndex:index]];
            [redPacketArray addObject:mode];
        }
        pd.datas = redPacketArray;
        
        return pd;
    }
    return nil;
}

@end
