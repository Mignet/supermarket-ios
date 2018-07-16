//
//  RankListMode.m
//  FinancialManager
//
//  Created by xnkj on 22/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "RankListMode.h"
#import "MyRankMode.h"

@implementation RankListMode

+ (instancetype)initRankListWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        RankListMode * pd = [[RankListMode alloc]init];
        
        pd.pageIndex = [NSString stringWithFormat:@"%@",[params objectForKey:XN_CS_MYCUSTOMERLIST_PAGEINDEX]];
        pd.pageSize = [NSString stringWithFormat:@"%@",[params objectForKey:XN_CS_MYCUSTOMERLIST_PAGESIZE]];
        pd.totalCount = [NSString stringWithFormat:@"%@",[params objectForKey:XN_CS_MYCUSTOMERLIST_TOTALCOUNT]];
        pd.pageCount = [NSString stringWithFormat:@"%@",[params objectForKey:XN_CS_MYCUSTOMERLIST_PAGECOUNT]];
        
        NSMutableArray * tmpArray = [NSMutableArray array];
        
        MyRankMode * mode = nil;
        for (NSDictionary * param in [params objectForKey:XN_CS_MYCUSTOMERLIST_DATA]) {
            
            mode = [MyRankMode initMyRankWithParams:param];
            
            [tmpArray addObject:mode];
        }
        
        pd.dataArray = tmpArray;
        
        return pd;
    }
    return nil;
}

@end
