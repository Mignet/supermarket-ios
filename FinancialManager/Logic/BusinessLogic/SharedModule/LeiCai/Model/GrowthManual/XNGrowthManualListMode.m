//
//  XNGrowthManualListMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/31/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNGrowthManualListMode.h"
#import "XNGrowthManualCategoryMode.h"
#import "XNGrowthManualCategoryItemMode.h"

@implementation XNGrowthManualListMode

//个人定制列表
+ (instancetype)initWithPersonalCustomListObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNGrowthManualListMode *mode = [[XNGrowthManualListMode alloc] init];
        XNGrowthManualCategoryItemMode *itemMode = nil;
        mode.datas = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in [params objectForKey:XN_GROWTH_MANUAL_LIST_MODE_DATAS])
        {
            itemMode = [XNGrowthManualCategoryItemMode initWithObject:dic];
            [mode.datas addObject:itemMode];
        }
        return mode;
    }
    return nil;
}

//成长手册分类
+ (instancetype)initWithCategoryObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNGrowthManualListMode *mode = [[XNGrowthManualListMode alloc] init];
        
        XNGrowthManualCategoryMode *itemMode = nil;
        mode.datas = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in [params objectForKey:XN_GROWTH_MANUAL_LIST_MODE_DATAS])
        {
            itemMode = [XNGrowthManualCategoryMode initWithObject:dic];
            [mode.datas addObject:itemMode];
        }
        return mode;
    }
    return nil;
}

//分类列表
+ (instancetype)initWithCategoryListObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNGrowthManualListMode *mode = [[XNGrowthManualListMode alloc] init];
        
        mode.bannerImg = [params objectForKey:XN_GROWTH_MANUAL_LIST_MODE_BANNERIMG];
        mode.pageIndex = [[params objectForKey:@"growthHandbookList"] objectForKey:XN_GROWTH_MANUAL_LIST_MODE_PAGEINDEX];
        mode.pageSize = [[params objectForKey:@"growthHandbookList"] objectForKey:XN_GROWTH_MANUAL_LIST_MODE_PAGESIZE];
        mode.pageCount = [[params objectForKey:@"growthHandbookList"] objectForKey:XN_GROWTH_MANUAL_LIST_MODE_PAGECOUNT];
        mode.totalCount = [[params objectForKey:@"growthHandbookList"] objectForKey:XN_GROWTH_MANUAL_LIST_MODE_TOTALCOUNT];
        mode.datas = [[NSMutableArray alloc] init];
        
        XNGrowthManualCategoryItemMode *itemMode = nil;
        for (NSDictionary *dic in [[params objectForKey:@"growthHandbookList"] objectForKey:XN_GROWTH_MANUAL_LIST_MODE_DATAS])
        {
            itemMode = [XNGrowthManualCategoryItemMode initWithObject:dic];
            [mode.datas addObject:itemMode];
        }
        return mode;
    }
    return nil;
}

@end
