//
//  XNFMAgentActivityMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 10/18/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_FM_AGENT_ACTIVITY_MODE_ORG_ACTIVITY_ADVERTISE @"platformImg"
#define XN_FM_AGENT_ACTIVITY_MODE_ORG_ACTIVITY_ADVERTISE_URL @"linkUrl"
#define XN_FM_AGENT_ACTIVITY_MODE_SHARE_DESC @"shareDesc"
#define XN_FM_AGENT_ACTIVITY_MODE_SHARE_ICON @"shareIcon"
#define XN_FM_AGENT_ACTIVITY_MODE_SHARE_LINK @"shareLink"
#define XN_FM_AGENT_ACTIVITY_MODE_SHARE_TITLE @"shareTitle"

@interface XNFMAgentActivityMode : NSObject

@property (nonatomic, strong) NSString *orgActivityAdvertise; //机构活动宣传图
@property (nonatomic, strong) NSString *orgActivityAdvertiseUrl; //机构活动宣传图跳转链接
@property (nonatomic, strong) NSString *shareDesc; //分享描述
@property (nonatomic, strong) NSString *shareIcon; //分享图标
@property (nonatomic, strong) NSString *shareLink; //分享链接
@property (nonatomic, strong) NSString *shareTitle; //分享标题

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
