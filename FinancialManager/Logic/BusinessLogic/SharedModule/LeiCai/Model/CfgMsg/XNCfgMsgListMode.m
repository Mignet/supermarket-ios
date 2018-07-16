//
//  XNCfgMsgListMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 10/10/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNCfgMsgListMode.h"
#import "XNCfgMsgItemMode.h"

@implementation XNCfgMsgListMode

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNCfgMsgListMode *mode = [[XNCfgMsgListMode alloc] init];
        mode.pageCount = [[params objectForKey:XN_CFG_MSG_LIST_MODE_PAGECOUNT] integerValue];
        mode.pageIndex = [[params objectForKey:XN_CFG_MSG_LIST_MODE_PAGEINDEX] integerValue];
        mode.pageSize = [[params objectForKey:XN_CFG_MSG_LIST_MODE_PAGESIZE] integerValue];
        mode.totalCount = [[params objectForKey:XN_CFG_MSG_LIST_MODE_TOTALCOUNT] integerValue];
        
        XNCfgMsgItemMode *itemMode = nil;
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dic in [params objectForKey:XN_CFG_MSG_LIST_MODE_DATAS])
        {
            itemMode = [XNCfgMsgItemMode initWithObject:dic];
            [array addObject:itemMode];
        }
        mode.datasArray = array;
        return mode;
    }
    return nil;
}

@end
