//
//  RedPacketListMode.m
//  FinancialManager
//
//  Created by xnkj on 6/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "ComissionCouponListMode.h"
#import "ComissionCouponItemMode.h"

@implementation ComissionCouponListMode

+ (instancetype )initRedPacketListWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        ComissionCouponListMode * pd = [[ComissionCouponListMode alloc]init];
        
        pd.pageIndex = [params objectForKey:XN_MYINFO_MYPROFIT_ITEM_PAGEINDEX];
        pd.pageSize = [params objectForKey:XN_MYINFO_MYPROFIT_ITEM_PAGESIZE];
        pd.pageCount = [params objectForKey:XN_MYINFO_MYPROFIT_ITEM_PAGECOUNT];
        pd.totalCount = [params objectForKey:XN_MYINFO_MYPROFIT_ITEM_TOTALCOUNT];
        
        
        ComissionCouponItemMode * mode = nil;
        NSMutableArray * redPacketArray = [NSMutableArray array];
        NSArray * data = [params objectForKey:XN_MYINFO_MYPROFIT_ITEM_DATA];
        for (NSInteger index = 0 ; index < data.count; index ++ ) {
            
            mode = [ComissionCouponItemMode initRedPacketInfoWithParams:[data objectAtIndex:index]];
            [redPacketArray addObject:mode];
        }
        pd.dataArray = redPacketArray;
        
        return pd;
    }
    return nil;
}

@end
