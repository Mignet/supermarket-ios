//
//  MIMonthProfixItemMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 11/24/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MONTH_PROFIX_ITEM_MODE_AMOUNT @"amount"
#define XN_MONTH_PROFIX_ITEM_MODE_DEADLINE @"deadline"
#define XN_MONTH_PROFIX_ITEM_MODE_DESC @"description"
#define XN_MONTH_PROFIX_ITEM_MODE_FEERATE @"feeRate"
#define XN_MONTH_PROFIX_ITEM_MODE_PROFIX_TYPE @"profixType"
#define XN_MONTH_PROFIX_ITEM_MODE_PROFIX_TYPE_NAME @"profixTypeName"
#define XN_MONTH_PROFIX_ITEM_MODE_TIME @"time"
#define XN_MONTH_PROFIX_ITEM_MODE_REMARK @"remark"
#define XN_MONTH_PROFIX_ITEM_MODE_PRODUCT_TYPE @"productType"
#define XN_MONTH_PROFIX_ITEM_MODE_PRODUCT_TYPE_DESC @"typeSuffix"

@interface MIMonthProfixItemMode : NSObject

@property (nonatomic, copy) NSString *amount; //金额
@property (nonatomic, copy) NSString *deadline; //产品期限
@property (nonatomic, copy) NSString *desc; //描述
@property (nonatomic, copy) NSString *feeRate; //年化佣金率；例：2.5%
@property (nonatomic, copy) NSString *profixType; //收益类型：1销售佣金，2推荐津贴，3投资返现红包，4团队leader奖励，5、T呗活动，6猎财活动
@property (nonatomic, copy) NSString *profixTypeName; //收益类型名称：例：销售佣金
@property (nonatomic, copy) NSString *time; //时间
@property (nonatomic, copy) NSString *remark; //问题描述
@property (nonatomic, copy) NSString *productType;//产品类型：1首投，2首投可赎回，3复投，4复投可赎回
@property (nonatomic, copy) NSString *productTypeDesc;

+ (instancetype )initWithObject:(NSDictionary *)params;

@end
