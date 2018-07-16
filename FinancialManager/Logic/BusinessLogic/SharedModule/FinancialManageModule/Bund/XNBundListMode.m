//
//  XNBundListMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNBundListMode.h"
#import "XNBundItemMode.h"
#import "XNMyBundRecordingItemMode.h"

@implementation XNBundListMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNBundListMode *mode = [[XNBundListMode alloc] init];
        mode.pageIndex = [params objectForKey:XN_BUND_LIST_MODE_PAGEINDEX];
        mode.pageSize = [params objectForKey:XN_BUND_LIST_MODE_PAGESIZE];
        mode.pageCount = [params objectForKey:XN_BUND_LIST_MODE_PAGECOUNT];
        mode.totalCount = [params objectForKey:XN_BUND_LIST_MODE_TOTALCOUNT];

        XNBundItemMode *itemMode = nil;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in [params objectForKey:XN_BUND_LIST_MODE_DATAS])
        {
            itemMode = [XNBundItemMode initWithObject:dic];
            [array addObject:itemMode];
        }
        mode.datas = array;
        
        return mode;
    }
    
    return nil;
}

+ (instancetype)initWithRecordingObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNBundListMode *mode = [[XNBundListMode alloc] init];
        mode.pageIndex = [params objectForKey:XN_BUND_LIST_MODE_PAGEINDEX];
        mode.pageSize = [params objectForKey:XN_BUND_LIST_MODE_PAGESIZE];
        mode.pageCount = [params objectForKey:XN_BUND_LIST_MODE_PAGECOUNT];
        mode.totalCount = [params objectForKey:XN_BUND_LIST_MODE_TOTALCOUNT];
        
        XNMyBundRecordingItemMode *itemMode = nil;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in [params objectForKey:XN_BUND_LIST_MODE_DATAS])
        {
            itemMode = [XNMyBundRecordingItemMode initWithObject:dic];
            [array addObject:itemMode];
        }
        mode.datas = array;
        return mode;
    }
    return nil;
}

@end
