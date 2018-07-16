//
//  XNFMAgentListItemMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/14/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_FM_AGENTLIST_ITEM_AVERAGERATE @"averageRate"
#define XN_FM_AGENTLIST_ITEM_GRADE @"grade"
#define XN_FM_AGENTLIST_ITEM_LISTRECOMMEND @"listRecommend"
#define XN_FM_AGENTLIST_ITEM_ORGADVANTAGE @"orgAdvantage"
#define XN_FM_AGENTLIST_ITEM_ORGFEERATIO @"orgFeeRatio"
#define XN_FM_AGENTLIST_ITEM_ORGTAG @"orgTag"
#define XN_FM_AGENTLIST_ITEM_PLATFORMLISTICO @"platformlistIco"
#define XN_FM_AGENTLIST_ITEM_USABLEPRODUCTNUMS @"usableProductNums"
#define XN_FM_AGENTLIST_ITEM_ORGNUMBER @"orgNumber"
#define XN_FM_AGENTLIST_ITEM_NAME @"name"

@interface XNFMAgentListItemMode : NSObject

@property (nonatomic, copy) NSString *averageRate; //平台近3个月平均年化收益率
@property (nonatomic, copy) NSString *grade; //安全评级
@property (nonatomic, assign) BOOL listRecommend; //是否列表推荐 	0-不推荐、1-推荐
@property (nonatomic, copy) NSString *orgAdvantage; //机构亮点介绍(多个以英文逗号分隔)
@property (nonatomic, copy) NSString *orgFeeRatio; //机构产品佣金率
@property (nonatomic, copy) NSString *orgTag; //机构标签(多个以英文逗号分隔)
@property (nonatomic, copy) NSString *platformlistIco; //平台列表logo
@property (nonatomic, copy) NSString *usableProductNums; //平台下可投的产品数量
@property (nonatomic, copy) NSString *orgNumber; //机构编码
@property (nonatomic, copy) NSString *name; //机构名称

+ (instancetype)initAgentListItemWithObject:(NSDictionary *)params;

@end
