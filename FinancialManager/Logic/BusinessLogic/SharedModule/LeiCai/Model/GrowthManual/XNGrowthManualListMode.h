//
//  XNGrowthManualListMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/31/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_GROWTH_MANUAL_LIST_MODE_BANNERIMG @"bannerImg"
#define XN_GROWTH_MANUAL_LIST_MODE_DATAS @"datas"
#define XN_GROWTH_MANUAL_LIST_MODE_PAGEINDEX @"pageIndex"
#define XN_GROWTH_MANUAL_LIST_MODE_PAGESIZE @"pageSize"
#define XN_GROWTH_MANUAL_LIST_MODE_PAGECOUNT @"pageCount"
#define XN_GROWTH_MANUAL_LIST_MODE_TOTALCOUNT @"totalCount"

@interface XNGrowthManualListMode : NSObject

@property (nonatomic, copy) NSString *bannerImg; //	头部图片
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, copy) NSString *pageIndex;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *pageCount;
@property (nonatomic, copy) NSString *totalCount;

//个人定制列表
+ (instancetype)initWithPersonalCustomListObject:(NSDictionary *)params;

//成长手册分类
+ (instancetype)initWithCategoryObject:(NSDictionary *)params;

//分类列表
+ (instancetype)initWithCategoryListObject:(NSDictionary *)params;

@end
