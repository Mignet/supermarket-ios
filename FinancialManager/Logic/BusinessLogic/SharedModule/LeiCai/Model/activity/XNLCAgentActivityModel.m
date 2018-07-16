//
//  XNLCAgentActivityModel.m
//  FinancialManager
//
//  Created by xnkj on 07/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNLCAgentActivityModel.h"

@implementation XNLCAgentActivityModel

+ (instancetype)initLCAgentActivityModeWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNLCAgentActivityModel * pd = [[XNLCAgentActivityModel alloc]init];
        
        pd.activityCode = [params objectForKey:@"activityCode"];
        pd.activityName = [params objectForKey:@"activityName"];
        pd.activityDesc = [params objectForKey:@"activityDesc"];
        pd.activityImg = [params objectForKey:@"activityImg"];
        pd.activityPlatform = [params objectForKey:@"activityPlatform"];
        pd.title = [params objectForKey:@"activityName"];
        pd.subTitle = [params objectForKey:@"endDate"];
        pd.startDate = [params objectForKey:@"startDate"];
        pd.endDate = [params objectForKey:@"endDate"];
        pd.activityStatus = [NSString stringWithFormat:@"%@",[params objectForKey:XN_LC_AGENT_ACTIVITY_ACTIVITYSTATUS]];
        pd.shareDesc = [params objectForKey:XN_LC_AGENT_ACTIVITY_SHAREDESC];
        pd.shareIcon = [params objectForKey:XN_LC_AGENT_ACTIVITY_SHAREICON];
        pd.shareLink = [params objectForKey:XN_LC_AGENT_ACTIVITY_SHARELINK];
        pd.shareTitle = [params objectForKey:XN_LC_AGENT_ACTIVITY_SHAREDTITLE];
        pd.linkUrl = [params objectForKey:XN_LC_AGENT_ACTIVITY_LINKURL];
        
        return pd;
    }
    
    return nil;
}
@end
