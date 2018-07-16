//
//  XNBundListMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_BUND_LIST_MODE_PAGEINDEX @"pageIndex"
#define XN_BUND_LIST_MODE_PAGESIZE @"pageSize"
#define XN_BUND_LIST_MODE_PAGECOUNT @"pageCount"
#define XN_BUND_LIST_MODE_TOTALCOUNT @"totalCount"
#define XN_BUND_LIST_MODE_DATAS @"datas"

@interface XNBundListMode : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSString * totalCount;
@property (nonatomic, strong) NSArray  * datas;

+ (instancetype)initWithObject:(NSDictionary *)params;

+ (instancetype)initWithRecordingObject:(NSDictionary *)params;

@end
