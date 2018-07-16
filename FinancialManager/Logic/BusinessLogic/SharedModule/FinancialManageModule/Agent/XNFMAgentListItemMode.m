//
//  XNFMAgentListItemMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/14/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNFMAgentListItemMode.h"
#import "XNAgentActivityItemMode.h"

@implementation XNFMAgentListItemMode

+ (instancetype )initAgentListItemWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNFMAgentListItemMode *mode = [[XNFMAgentListItemMode alloc] init];
        
        mode.averageRate = [params objectForKey:XN_FM_AGENTLIST_ITEM_AVERAGERATE];
        mode.grade = [params objectForKey:XN_FM_AGENTLIST_ITEM_GRADE];
        mode.listRecommend = [[params objectForKey:XN_FM_AGENTLIST_ITEM_LISTRECOMMEND] boolValue];
        
        mode.orgAdvantage = [params objectForKey:XN_FM_AGENTLIST_ITEM_ORGADVANTAGE];
        mode.orgFeeRatio = [NSString stringWithFormat:@"%@", [params objectForKey:XN_FM_AGENTLIST_ITEM_ORGFEERATIO]];
        mode.orgTag = [params objectForKey:XN_FM_AGENTLIST_ITEM_ORGTAG];
        mode.platformlistIco = [params objectForKey:XN_FM_AGENTLIST_ITEM_PLATFORMLISTICO];
        mode.usableProductNums = [NSString stringWithFormat:@"%@", [params objectForKey:XN_FM_AGENTLIST_ITEM_USABLEPRODUCTNUMS]];
        mode.orgNumber = [params objectForKey:XN_FM_AGENTLIST_ITEM_ORGNUMBER];
        mode.name = [params objectForKey:XN_FM_AGENTLIST_ITEM_NAME];
    
        return mode;
    }
    return nil;
}

@end
