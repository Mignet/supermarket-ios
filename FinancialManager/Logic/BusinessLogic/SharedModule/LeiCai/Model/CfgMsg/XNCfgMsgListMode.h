//
//  XNCfgMsgListMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 10/10/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_CFG_MSG_LIST_MODE_PAGECOUNT @"pageCount"
#define XN_CFG_MSG_LIST_MODE_PAGEINDEX @"pageIndex"
#define XN_CFG_MSG_LIST_MODE_PAGESIZE @"pageSize"
#define XN_CFG_MSG_LIST_MODE_TOTALCOUNT @"totalCount"
#define XN_CFG_MSG_LIST_MODE_DATAS @"datas"

@interface XNCfgMsgListMode : NSObject

@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, strong) NSArray *datasArray;

+ (instancetype )initWithObject:(NSDictionary *)params;

@end
