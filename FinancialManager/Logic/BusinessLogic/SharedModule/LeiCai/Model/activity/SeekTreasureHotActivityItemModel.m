//
//  SeekTreasureHotActivityItemModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekTreasureHotActivityItemModel.h"

@implementation SeekTreasureHotActivityItemModel

+ (instancetype)initSeekTreasureHotActivityItemModelParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        SeekTreasureHotActivityItemModel * pd = [[SeekTreasureHotActivityItemModel alloc] init];
        
        pd.activityCode = [params objectForKey:SEEK_TREASURE_ACTIVITY_activityCode];
        pd.activityDesc = [params objectForKey:SEEK_TREASURE_ACTIVITY_activityDesc];
        pd.activityEndImg = [params objectForKey:SEEK_TREASURE_ACTIVITY_activityEndImg];
        pd.activityImg = [params objectForKey:SEEK_TREASURE_ACTIVITY_activityImg];
        pd.activityName = [params objectForKey:SEEK_TREASURE_ACTIVITY_activityName];
        pd.activityPlatform = [params objectForKey:SEEK_TREASURE_ACTIVITY_activityPlatform];
        pd.activityStatus = [params objectForKey:SEEK_TREASURE_ACTIVITY_activityStatus];
        pd.activityType = [params objectForKey:SEEK_TREASURE_ACTIVITY_activityType];
        pd.appType = [params objectForKey:SEEK_TREASURE_ACTIVITY_appType];
        pd.endDate = [params objectForKey:SEEK_TREASURE_ACTIVITY_endDate];
        pd.id = [params objectForKey:SEEK_TREASURE_ACTIVITY_id];
        pd.isCover = [params objectForKey:SEEK_TREASURE_ACTIVITY_isCover];
        pd.linkUrl = [params objectForKey:SEEK_TREASURE_ACTIVITY_linkUrl];
        pd.platformImg = [params objectForKey:SEEK_TREASURE_ACTIVITY_platformImg];
        pd.prizeBalanceTime = [params objectForKey:SEEK_TREASURE_ACTIVITY_prizeBalanceTime];
        pd.prizeIssueStyle = [params objectForKey:SEEK_TREASURE_ACTIVITY_prizeIssueStyle];
        pd.shareDesc = [params objectForKey:SEEK_TREASURE_ACTIVITY_shareDesc];
        pd.shareIcon = [params objectForKey:SEEK_TREASURE_ACTIVITY_shareIcon];
        pd.shareLink = [params objectForKey:SEEK_TREASURE_ACTIVITY_shareLink];
        pd.shareTitle = [params objectForKey:SEEK_TREASURE_ACTIVITY_shareTitle];
        pd.showIndex = [params objectForKey:SEEK_TREASURE_ACTIVITY_showIndex];
        pd.startDate = [params objectForKey:SEEK_TREASURE_ACTIVITY_startDate];
        pd.status = [params objectForKey:SEEK_TREASURE_ACTIVITY_status];
        
        return pd;
    }
    
    return nil;


}

@end
