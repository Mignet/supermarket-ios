//
//  XNFMAgentDetailMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNFMAgentDetailMode.h"
#import "XNFMAgentTeamDetailMode.h"
#import "XNFMAgentActivityMode.h"

@implementation XNFMAgentDetailMode

+ (instancetype)initAgentDetailWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNFMAgentDetailMode *mode = [[XNFMAgentDetailMode alloc] init];
        mode.capital = [params objectForKey:XN_FM_AGENT_DETAIL_CAPITAL];
        mode.city = [params objectForKey:XN_FM_AGENT_DETAIL_CITY];
        mode.feeRateMax = [params objectForKey:XN_FM_AGENT_DETAIL_FEERATE_MAX];
        mode.feeRateMin = [params objectForKey:XN_FM_AGENT_DETAIL_FEERATE_MIN];
        mode.icp = [params objectForKey:XN_FM_AGENT_DETAIL_ICP];
        mode.orgBack = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_BACK];
        mode.orgLevel = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_LEVEL];
        mode.orgLogo = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_LOGO];
        mode.orgName = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_NAME];
        mode.orgNo = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_NO];
        mode.orgProfile = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_PROFILE];
        mode.orgSecurity = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_SECURITY];
        mode.orgUrl = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_URL];
        mode.proDaysMax = [params objectForKey:XN_FM_AGENT_DETAIL_PRODAYS_MAX];
        mode.proDaysMin = [params objectForKey:XN_FM_AGENT_DETAIL_PRODAYS_MIN];
        mode.trusteeship = [params objectForKey:XN_FM_AGENT_DETAIL_TRUSTEE_SHIP];
        mode.upTime = [params objectForKey:XN_FM_AGENT_DETAIL_UPTIME];
        mode.deadLineMaxSelfDefined = [params objectForKey:XN_FM_AGENT_DETAIL_DEADLINE_MAX_SELF_DEFINED];
        mode.deadLineMinSelfDefined = [params objectForKey:XN_FM_AGENT_DETAIL_DEADLINE_MIN_SELF_DEFINED];
        mode.deadLineValueText = [params objectForKey:XN_FM_AGENT_DETAIL_DEADLINE_VALUE_TEXT];
        
        XNFMAgentActivityMode *activityMode = nil;
        NSMutableArray *activityArray = [NSMutableArray array];
        for (NSDictionary *dic in [params objectForKey:XN_FM_AGENT_DETAIL_DEADLINE_ORG_ADVERTISES])
        {
            activityMode = [XNFMAgentActivityMode initWithObject:dic];
            [activityArray addObject:activityMode];
        }
        mode.orgAdvertises = activityArray;
        
        mode.orgAdvantage = [params objectForKey:XN_FM_AGENT_DETAIL_DEADLINE_ORG_ADVANTAGE];
        mode.orgPlannerStrategy = [params objectForKey:XN_FM_AGENT_DETAIL_DEADLINE_ORG_PLANNER_STRATEGY];
        mode.orgProductTag = [params objectForKey:XN_FM_AGENT_DETAIL_DEADLINE_ORG_PRODUCT_TAG];
        mode.orgTag = [params objectForKey:XN_FM_AGENT_DETAIL_DEADLINE_ORG_TAG];
        mode.platformIco = [params objectForKey:XN_FM_AGENT_DETAIL_DEADLINE_PLATFORM_ICO];
        mode.orgIsstaticproduct = [[params objectForKey:XN_FM_AGENT_DETAIL_DEADLINE_ORG_ISSTATIC_PRODUCT] integerValue];
        
        XNFMAgentTeamDetailMode *teamMode = nil;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in [params objectForKey:XN_FM_AGENT_DETAIL_TEAM_INFOS])
        {
            teamMode = [XNFMAgentTeamDetailMode initAgentTeamDetailWithObject:dic];
            [array addObject:teamMode];
        }
        mode.teamInfos = array;
        
        mode.orgDynamicList = [params objectForKey:XN_FM_AGENT_DETAIL_DYNAMIC_LIST];
        mode.orgEnvironmentList = [params objectForKey:XN_FM_AGENT_DETAIL_ENVIRONMENT_LIST];
        mode.orgHonor = [params objectForKey:XN_FM_AGENT_DETAIL_HONOR];
        mode.orgHonorList = [params objectForKey:XN_FM_AGENT_DETAIL_HONOR_LIST];
        mode.orgPapersList = [params objectForKey:XN_FM_AGENT_DETAIL_PAPERS_LIST];
        
        mode.orgCertificatesList = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_CERTIFICATES_LIST];
        mode.productReleaseTime = [params objectForKey:XN_FM_AGENT_DETAIL_PRODUCT_RELEASE_TIME];
        mode.rechargeLimitDescription = [params objectForKey:XN_FM_AGENT_DETAIL_RECHARGE_LIMIT_DESCRIPTION];
        mode.rechargeLimitTitle = [params objectForKey:XN_FM_AGENT_DETAIL_RECHARGE_LIMIT_TITLE];
        mode.rechargeLimitLinkUrl = [params objectForKey:XN_FM_AGENT_DETAIL_RECHARGE_LIMIT_LINK_URL];
        mode.interestTime = [params objectForKey:XN_FM_AGENT_DETAIL_INTEREST_TIME];
        mode.withdrawalCharges = [params objectForKey:XN_FM_AGENT_DETAIL_WITHDRAWAL_CHARGES];
        mode.cashInTime = [params objectForKey:XN_FM_AGENT_DETAIL_CASHIN_TIME];
        mode.investOthers = [params objectForKey:XN_FM_AGENT_DETAIL_INVEST_OTHERS];
        mode.contact = [params objectForKey:XN_FM_AGENT_DETAIL_CONTACT];
        
        mode.orgFeeRatio = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_FEE_RATIO];
        mode.orgFeeRatioLimit = [params objectForKey:XN_FM_AGENT_DETAIL_ORG_FEE_RATIO_LIMIT];
        mode.shareDesc = [params objectForKey:XN_FM_AGENT_DETAIL_SHARE_DESC];
        mode.shareIcon = [params objectForKey:XN_FM_AGENT_DETAIL_SHARE_ICON];
        mode.shareLink = [params objectForKey:XN_FM_AGENT_DETAIL_SHARE_LINK];
        mode.shareTitle = [params objectForKey:XN_FM_AGENT_DETAIL_SHARE_TITLE];
        
        return mode;
    }
    return nil;
}

@end
