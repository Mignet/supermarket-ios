//
//  XNFMAgentListMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/14/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNFMAgentListMode.h"
#import "XNFMAgentListItemMode.h"

@implementation XNFMAgentListMode

+ (instancetype )initAgentListWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNFMAgentListMode *mode = [[XNFMAgentListMode alloc] init];
        mode.pageIndex = [params objectForKey:XN_FM_AGENTLIST_PAGE_INDEX];
        mode.pageSize = [params objectForKey:XN_FM_AGENTLIST_PAGE_SIZE];
        mode.pageCount = [params objectForKey:XN_FM_AGENTLIST_PAGE_COUNT];
        mode.totalCount = [params objectForKey:XN_FM_AGENTLIST_TOTAL_COUNT];
        
        XNFMAgentListItemMode *itemMode = nil;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in [params objectForKey:XN_FM_AGENTLIST_DATAS])
        {
            itemMode = [XNFMAgentListItemMode initAgentListItemWithObject:dic];
            [array addObject:itemMode];
        }
        mode.datas = array;
        return mode;
    }
    return nil;
}

@end
