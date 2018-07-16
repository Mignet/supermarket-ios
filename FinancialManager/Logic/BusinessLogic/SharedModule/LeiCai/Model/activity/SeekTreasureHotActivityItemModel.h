//
//  SeekTreasureHotActivityItemModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SEEK_TREASURE_ACTIVITY_activityCode        @"activityCode"
#define SEEK_TREASURE_ACTIVITY_activityDesc        @"activityDesc"
#define SEEK_TREASURE_ACTIVITY_activityEndImg      @"activityEndImg"
#define SEEK_TREASURE_ACTIVITY_activityImg         @"activityImg"
#define SEEK_TREASURE_ACTIVITY_activityName        @"activityName"


#define SEEK_TREASURE_ACTIVITY_activityPlatform    @"activityPlatform"
#define SEEK_TREASURE_ACTIVITY_activityStatus      @"activityStatus"
#define SEEK_TREASURE_ACTIVITY_activityType        @"activityType"
#define SEEK_TREASURE_ACTIVITY_appType             @"appType"
#define SEEK_TREASURE_ACTIVITY_endDate             @"endDate"

#define SEEK_TREASURE_ACTIVITY_id                  @"id"
#define SEEK_TREASURE_ACTIVITY_isCover             @"isCover"
#define SEEK_TREASURE_ACTIVITY_linkUrl             @"linkUrl"
#define SEEK_TREASURE_ACTIVITY_platformImg         @"platformImg"
#define SEEK_TREASURE_ACTIVITY_prizeBalanceTime    @"prizeBalanceTime"



#define SEEK_TREASURE_ACTIVITY_prizeIssueStyle     @"prizeIssueStyle"
#define SEEK_TREASURE_ACTIVITY_shareDesc           @"shareDesc"
#define SEEK_TREASURE_ACTIVITY_shareIcon           @"shareIcon"
#define SEEK_TREASURE_ACTIVITY_shareLink           @"shareLink"
#define SEEK_TREASURE_ACTIVITY_shareTitle          @"shareTitle"
#define SEEK_TREASURE_ACTIVITY_showIndex           @"showIndex"
#define SEEK_TREASURE_ACTIVITY_startDate           @"startDate"
#define SEEK_TREASURE_ACTIVITY_status              @"status"




@interface SeekTreasureHotActivityItemModel : NSObject

@property (nonatomic, copy) NSString *activityCode;
@property (nonatomic, copy) NSString *activityDesc;
@property (nonatomic, copy) NSString *activityEndImg;
@property (nonatomic, copy) NSString *activityImg;
@property (nonatomic, copy) NSString *activityName;

@property (nonatomic, copy) NSString *activityPlatform;
@property (nonatomic, copy) NSString *activityStatus;
@property (nonatomic, copy) NSString *activityType;
@property (nonatomic, copy) NSString *appType;
@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *isCover;
@property (nonatomic, copy) NSString *linkUrl;
@property (nonatomic, copy) NSString *platformImg;
@property (nonatomic, copy) NSString *prizeBalanceTime;

@property (nonatomic, copy) NSString *prizeIssueStyle;
@property (nonatomic, copy) NSString *shareDesc;
@property (nonatomic, copy) NSString *shareIcon;
@property (nonatomic, copy) NSString *shareLink;
@property (nonatomic, copy) NSString *shareTitle;

@property (nonatomic, copy) NSString *showIndex;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *status;

+ (instancetype)initSeekTreasureHotActivityItemModelParams:(NSDictionary *)params;

@end
