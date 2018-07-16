//
//  XNAgentActivityItemMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 11/4/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNAgentActivityItemMode.h"

@implementation XNAgentActivityItemMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNAgentActivityItemMode *mode = [[XNAgentActivityItemMode alloc] init];
        mode.activityName = [params objectForKey:XN_FM_AGENT_ACTIVITY_ITEM_MODE_ACTIVITY_NAME];
        mode.activityUrl = [params objectForKey:XN_FM_AGENT_ACTIVITY_ITEM_MODE_LINK_URL];
        mode.shareDesc = [params objectForKey:XN_FM_AGENT_ACTIVITY_ITEM_MODE_SHARE_DESC];
        mode.shareIcon = [params objectForKey:XN_FM_AGENT_ACTIVITY_ITEM_MODE_SHARE_ICON];
        mode.shareLink = [params objectForKey:XN_FM_AGENT_ACTIVITY_ITEM_MODE_SHARE_LINK];
        mode.shareTitle = [params objectForKey:XN_FM_AGENT_ACTIVITY_ITEM_MODE_SHARE_TITLE];
        
        return mode;
    }
    return nil;
}

@end
