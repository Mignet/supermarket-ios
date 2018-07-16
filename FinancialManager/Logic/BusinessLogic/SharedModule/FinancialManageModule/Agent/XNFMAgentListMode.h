//
//  XNFMAgentListMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/14/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_FM_AGENTLIST_PAGE_INDEX @"pageIndex"
#define XN_FM_AGENTLIST_PAGE_SIZE @"pageSize"
#define XN_FM_AGENTLIST_PAGE_COUNT @"pageCount"
#define XN_FM_AGENTLIST_TOTAL_COUNT @"totalCount"
#define XN_FM_AGENTLIST_DATAS @"datas"

@interface XNFMAgentListMode : NSObject

@property (nonatomic, strong) NSString *pageIndex; //当前页码
@property (nonatomic, strong) NSString *pageSize; //页面大小
@property (nonatomic, strong) NSString *pageCount; //总页数
@property (nonatomic, strong) NSString *totalCount; //总条数
@property (nonatomic, strong) NSArray *datas;

+ (instancetype)initAgentListWithObject:(NSDictionary *)params;

@end
