//
//  XNFMAgentTeamDetailMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/25/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNFMAgentTeamDetailMode.h"

@implementation XNFMAgentTeamDetailMode

+ (instancetype)initAgentTeamDetailWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNFMAgentTeamDetailMode *mode = [[XNFMAgentTeamDetailMode alloc] init];
        mode.orgDescribe = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_DESCRIBE];
        mode.orgMemberGrade = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_MEMBER_GRADE];
        mode.orgMemberName = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_MEMBER_NAME];
        mode.orgIcon = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_Icon];
        
        return mode;
    }
    return nil;
    
}

@end
