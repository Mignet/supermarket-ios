//
//  XNAgentActivityItemMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 11/4/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_FM_AGENT_ACTIVITY_ITEM_MODE_ACTIVITY_NAME @"activityName"
#define XN_FM_AGENT_ACTIVITY_ITEM_MODE_LINK_URL @"linkUrl"
#define XN_FM_AGENT_ACTIVITY_ITEM_MODE_SHARE_DESC @"shareDesc"
#define XN_FM_AGENT_ACTIVITY_ITEM_MODE_SHARE_ICON @"shareIcon"
#define XN_FM_AGENT_ACTIVITY_ITEM_MODE_SHARE_LINK @"shareLink"
#define XN_FM_AGENT_ACTIVITY_ITEM_MODE_SHARE_TITLE @"shareTitle"

@interface XNAgentActivityItemMode : NSObject

@property (nonatomic, strong) NSString *activityName; //活动名称
@property (nonatomic, strong) NSString *activityUrl; //	活动链接
@property (nonatomic, strong) NSString *shareDesc; //分享详情
@property (nonatomic, strong) NSString *shareIcon; //分享图片
@property (nonatomic, strong) NSString *shareLink; //分享链接
@property (nonatomic, strong) NSString *shareTitle; //分享标题

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
