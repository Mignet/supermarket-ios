//
//  SeekActivityItemModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SEEK_TREASURE_ACTIVITY_activityId        @"activityId"
#define SEEK_TREASURE_ACTIVITY_activityImg       @"activityImg"
#define SEEK_TREASURE_ACTIVITY_activityName      @"activityName"
#define SEEK_TREASURE_ACTIVITY_linkUrl           @"linkUrl"
#define SEEK_TREASURE_ACTIVITY_status            @"status"
#define SEEK_TREASURE_ACTIVITY_endDate           @"endDate"
#define SEEK_TREASURE_ACTIVITY_startDate         @"startDate"
#define SEEK_TREASURE_ACTIVITY_leftDay           @"leftDay"
#define SEEK_TREASURE_ACTIVITY_shareContent      @"shareContent"
#define SEEK_TREASURE_ACTIVITY_activityPlatform  @"activityPlatform"

@interface SeekActivityItemModel : NSObject

@property (nonatomic, copy) NSString *activityId;
@property (nonatomic, copy) NSString *activityImg;
@property (nonatomic, copy) NSString *activityName;
@property (nonatomic, copy) NSString *linkUrl;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *leftDay;

/*** 平台名称 **/
@property (copy, nonatomic) NSString *activityPlatform;
@property (nonatomic, strong) NSDictionary *shareContent;

//活动状态:0:进行中，1:已结束，-1:即将开始
@property (nonatomic, copy) NSString *status;

+ (instancetype )initWithObject:(NSDictionary *)params;

@end

