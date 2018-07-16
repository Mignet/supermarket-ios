//
//  XNFMInvitedListMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNInvitedListMode.h"

#import "XNInvitedItemMode.h"

@implementation XNInvitedListMode

+ (instancetype )initInvitedListWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNInvitedListMode * pd = [[XNInvitedListMode alloc]init];
        
        pd.pageIndex  = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FM_INVITEDLIST_PAGEINDEX]];
        pd.pageSize   = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FM_INVITEDLIST_PAGESIZE]];
        pd.pageCount  = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FM_INVITEDLIST_PAGECOUNT]];
        pd.totalCount = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FM_INVITEDLIST_TOTALCOUNT]];
        
        //计算数组
        XNInvitedItemMode * item = nil;
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * obj in [params objectForKey:XN_FM_INVITEDLIST_DATA]) {
            
            item = [XNInvitedItemMode initInvitedItemWithObject:obj];
            
            [array addObject:item];
        }
        pd.dataArray = [NSArray arrayWithArray:array];
        
        return pd;
    }
    return nil;
}
@end
