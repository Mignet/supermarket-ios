//
//  LieCaiMode.h
//  FinancialManager
//
//  Created by xnkj on 02/03/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_LIECAI_HOME_UNFINISHNEWCOMMERTASKCOUNT @"unFinishNewcomerTaskCount"
#define XN_LIECAI_HOME_ACTIVITYREADED_STATUS @"activityReaded"
#define XN_LIECAI_HOME_CLASSROOM_STATUS @"classroomReaded"
#define XN_LIECAI_HOME_NEWSREADED_STATUS @"newsReaded"

@interface LieCaiMode : NSObject

@property (nonatomic, strong) NSString * unFinishNewComerTaskCount;
@property (nonatomic, strong) NSString * activityReadedStatus;
@property (nonatomic, strong) NSString * classRoomReadedStatus;
@property (nonatomic, strong) NSString * newsReadedStatus;

+ (instancetype)initLieCaiWithParams:(NSDictionary *)params;
@end
