//
//  XNGrowthManualCategoryMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/31/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_GROWTH_MANUAL_CATEGORY_MODE_ICON @"icon"
#define XN_GROWTH_MANUAL_CATEGORY_MODE_NAME @"name"
#define XN_GROWTH_MANUAL_CATEGORY_MODE_CATEID @"id"
#define XN_GROWTH_MANUAL_CATEGORY_MODE_DESC @"description"

@interface XNGrowthManualCategoryMode : NSObject

@property (nonatomic, copy) NSString *icon; //图标
@property (nonatomic, copy) NSString *name; //类型名
@property (nonatomic, copy) NSString *cateId; //类型Id
@property (nonatomic, copy) NSString *desc; //描述

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
