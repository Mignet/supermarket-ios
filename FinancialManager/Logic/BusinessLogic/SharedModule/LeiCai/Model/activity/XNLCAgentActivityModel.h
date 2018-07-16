//
//  XNLCAgentActivityModel.h
//  FinancialManager
//
//  Created by xnkj on 07/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNLCActivityModel.h"

#define XN_LC_AGENT_ACTIVITY_ACTIVITYSTATUS @"activityStatus"
#define XN_LC_AGENT_ACTIVITY_LINKURL @"linkUrl"
#define XN_LC_AGENT_ACTIVITY_SHAREDESC @"shareDesc"
#define XN_LC_AGENT_ACTIVITY_SHAREICON @"shareIcon"
#define XN_LC_AGENT_ACTIVITY_SHARELINK @"shareLink"
#define XN_LC_AGENT_ACTIVITY_SHAREDTITLE @"shareTitle"

@interface XNLCAgentActivityModel : NSObject

@property (nonatomic, strong) NSString * activityCode;
@property (nonatomic, strong) NSString * activityDesc;
@property (nonatomic, strong) NSString * activityImg;
@property (nonatomic, strong) NSString * activityName;
@property (nonatomic, strong) NSString * activityPlatform;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * subTitle;
@property (nonatomic, strong) NSString * startDate;
@property (nonatomic, strong) NSString * endDate;
@property (nonatomic, strong) NSString * activityStatus;//活动状态 0表示进行中，1表示进行中
@property (nonatomic, strong) NSString * linkUrl;//跳转链接
@property (nonatomic, strong) NSString * shareDesc;
@property (nonatomic, strong) NSString * shareIcon;
@property (nonatomic, strong) NSString * shareLink;
@property (nonatomic, strong) NSString * shareTitle;

+ (instancetype)initLCAgentActivityModeWithParams:(NSDictionary *)params;
@end
