//
//  XNCommonMsgListMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNCommonMsgListMode.h"

#import "XNCommonMsgItemMode.h"

@implementation XNCommonMsgListMode

+ (instancetype )initCommonMsgListWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNCommonMsgListMode * pd = [[XNCommonMsgListMode alloc]init];
        
        pd.pageIndex  = [params objectForKey:XN_FM_INVITEDLIST_PAGEINDEX];
        pd.pageSize   = [params objectForKey:XN_FM_INVITEDLIST_PAGESIZE];
        pd.pageCount  = [params objectForKey:XN_FM_INVITEDLIST_PAGECOUNT];
        pd.totalCount = [params objectForKey:XN_FM_INVITEDLIST_TOTALCOUNT];
        
        //计算数组
        XNCommonMsgItemMode * item = nil;
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * obj in [params objectForKey:XN_FM_INVITEDLIST_DATA]) {
            
            item = [XNCommonMsgItemMode initCommonMsgWithObject:obj];
            
            [array addObject:item];
        }
        pd.dataArray = array;
        
        return pd;

    }
    return nil;
}
@end
