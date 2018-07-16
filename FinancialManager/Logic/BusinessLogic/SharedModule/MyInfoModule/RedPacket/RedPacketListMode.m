//
//  RedPacketListMode.m
//  FinancialManager
//
//  Created by xnkj on 6/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "RedPacketListMode.h"
#import "RedPacketInfoMode.h"

@implementation RedPacketListMode

+ (instancetype )initRedPacketListWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        RedPacketListMode * pd = [[RedPacketListMode alloc]init];
        
        pd.pageIndex = [params objectForKey:XN_MYINFO_MYPROFIT_ITEM_PAGEINDEX];
        pd.pageSize = [params objectForKey:XN_MYINFO_MYPROFIT_ITEM_PAGESIZE];
        pd.pageCount = [params objectForKey:XN_MYINFO_MYPROFIT_ITEM_PAGECOUNT];
        pd.totalCount = [params objectForKey:XN_MYINFO_MYPROFIT_ITEM_TOTALCOUNT];
        
        
        RedPacketInfoMode * mode = nil;
        NSMutableArray * redPacketArray = [NSMutableArray array];
        NSArray * data = [params objectForKey:XN_MYINFO_MYPROFIT_ITEM_DATA];
        for (NSInteger index = 0 ; index < data.count; index ++ ) {
            
            mode = [RedPacketInfoMode initRedPacketInfoWithParams:[data objectAtIndex:index]];
            [redPacketArray addObject:mode];
        }
        pd.redPacketArray = redPacketArray;
        
        return pd;
    }
    return nil;
}

@end
