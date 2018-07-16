//
//  SeekActivityItemModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekActivityItemModel.h"

@implementation SeekActivityItemModel

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        SeekActivityItemModel *pd = [[SeekActivityItemModel alloc] init];
        
        pd.activityId = [params objectForKey:SEEK_TREASURE_ACTIVITY_activityId];
        pd.activityImg = [params objectForKey:SEEK_TREASURE_ACTIVITY_activityImg];
        pd.activityName = [params objectForKey:SEEK_TREASURE_ACTIVITY_activityName];
        pd.endDate = [params objectForKey:SEEK_TREASURE_ACTIVITY_endDate];
        pd.startDate = [params objectForKey:SEEK_TREASURE_ACTIVITY_startDate];
        pd.leftDay = [params objectForKey:SEEK_TREASURE_ACTIVITY_leftDay];
        pd.linkUrl = [params objectForKey:SEEK_TREASURE_ACTIVITY_linkUrl];
        pd.status = [params objectForKey:SEEK_TREASURE_ACTIVITY_status];
        pd.shareContent = [params objectForKey:SEEK_TREASURE_ACTIVITY_shareContent];
        pd.activityPlatform = [params objectForKey:SEEK_TREASURE_ACTIVITY_activityPlatform];
        
        return pd;
    }
    return nil;
}

@end
