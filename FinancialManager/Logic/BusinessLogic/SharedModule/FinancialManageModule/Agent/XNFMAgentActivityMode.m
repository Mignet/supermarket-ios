//
//  XNFMAgentActivityMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 10/18/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNFMAgentActivityMode.h"

@implementation XNFMAgentActivityMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNFMAgentActivityMode *mode = [[XNFMAgentActivityMode alloc] init];
        mode.orgActivityAdvertise = [params objectForKey:XN_FM_AGENT_ACTIVITY_MODE_ORG_ACTIVITY_ADVERTISE];
        mode.orgActivityAdvertiseUrl = [params objectForKey:XN_FM_AGENT_ACTIVITY_MODE_ORG_ACTIVITY_ADVERTISE_URL];
        mode.shareDesc = [params objectForKey:XN_FM_AGENT_ACTIVITY_MODE_SHARE_DESC];
        mode.shareIcon = [params objectForKey:XN_FM_AGENT_ACTIVITY_MODE_SHARE_ICON];
        mode.shareLink = [params objectForKey:XN_FM_AGENT_ACTIVITY_MODE_SHARE_LINK];
        mode.shareTitle = [params objectForKey:XN_FM_AGENT_ACTIVITY_MODE_SHARE_TITLE];
        
        return mode;
    }
    return nil;
}

@end
