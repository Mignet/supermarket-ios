//
//  LieCaiMode.m
//  FinancialManager
//
//  Created by xnkj on 02/03/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "LieCaiMode.h"

@implementation LieCaiMode

+ (instancetype)initLieCaiWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        LieCaiMode * pd = [[LieCaiMode alloc]init];
        
        pd.unFinishNewComerTaskCount = [NSString stringWithFormat:@"%@",[params objectForKey:XN_LIECAI_HOME_UNFINISHNEWCOMMERTASKCOUNT]];
        pd.activityReadedStatus = [NSString stringWithFormat:@"%@",[params objectForKey:XN_LIECAI_HOME_ACTIVITYREADED_STATUS]];
        pd.classRoomReadedStatus = [NSString stringWithFormat:@"%@",[params objectForKey:XN_LIECAI_HOME_CLASSROOM_STATUS]];
        pd.newsReadedStatus = [NSString stringWithFormat:@"%@",[params objectForKey:XN_LIECAI_HOME_NEWSREADED_STATUS]];
        
        return pd;
    }
    return nil;
}
@end
