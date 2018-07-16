//
//  XNGrowthManualCategoryItemMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/31/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_ID @"id"
#define XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_IMG @"img"
#define XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_TITLE @"title"
#define XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_TYPECODE @"typeCode"
#define XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_TYPENAME @"typeName"
#define XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_READINGAMOUNT @"readingAmount"

#define XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_SHAREICON @"shareIcon"
#define XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_LINKURL @"linkUrl"
#define XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_SUMMARY @"summary"

@interface XNGrowthManualCategoryItemMode : NSObject

@property (nonatomic, copy) NSString *nId;
@property (nonatomic, copy) NSString *img; //图片
@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *typeCode; //类型编号
@property (nonatomic, copy) NSString *typeName; //类型名称
@property (nonatomic, copy) NSString *readingAmount; //阅读量

@property (nonatomic, copy) NSString *shareIcon; //分享图标
@property (nonatomic, copy) NSString *linkUrl; //链接
@property (nonatomic, copy) NSString *summary; //简介

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
