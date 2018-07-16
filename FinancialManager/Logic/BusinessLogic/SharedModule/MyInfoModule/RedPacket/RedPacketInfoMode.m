//
//  RedPacketInfoMode.m
//  FinancialManager
//
//  Created by xnkj on 6/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "RedPacketInfoMode.h"

@implementation RedPacketInfoMode

+ (instancetype)initRedPacketInfoWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]  && [params isKindOfClass:[NSDictionary class]]) {
        
        RedPacketInfoMode * pd = [[RedPacketInfoMode alloc]init];
        
        pd.redPacketDateDesc = [params objectForKey:XN_MI_RP_INFO_DATESTR];
        pd.redPacketName = [params objectForKey:XN_MI_RP_INFO_SHOWNAME];
        pd.redPacketCount = [params objectForKey:XN_MI_RP_INFO_REDPAPERCOUNT];
        pd.redPacketMoney = [params objectForKey:XN_MI_RP_INFO_REDPAPERMONEY];
        pd.redPacketRemark = [params objectForKey:XN_MI_RP_INFO_USEREMARK];
        pd.redPacketRid = [params objectForKey:XN_MI_RP_INFO_RID];
        pd.redPacketUseStatus = [params objectForKey:XN_MI_RP_INFO_USERSTATUS];
        pd.userImage = [params objectForKey:XN_MI_RP_INFO_USERIMAGE];
        pd.userMobile = [params objectForKey:XN_MI_RP_INFO_USERMOBILE];
        pd.userName = [params objectForKey:XN_MI_RP_INFO_USERNAME];

        pd.nInvestLimit = [[params objectForKey:XN_MI_RP_INFO_INVEST_LIMIT] integerValue];
        pd.nProductLimit = [[params objectForKey:XN_MI_RP_INFO_PRODUCT_LIMIT] integerValue];
        pd.productName = [params objectForKey:XN_MI_RP_INFO_PRODUCT_NAME];
        pd.productDeadline = [params objectForKey:XN_MI_RP_INFO_PRODUCT_DEADLINE];
        pd.isPlatformLimit = [[params objectForKey:XN_MI_RP_INFO_IS_PLATFORM_LIMIT] boolValue];
        pd.platform = [params objectForKey:XN_MI_RP_INFO_PLATFORM];
        pd.cfpIfSend = [NSString stringWithFormat:@"%@",[params objectForKey:XN_MI_RP_INFO_CFPIFSEND]];
        pd.expireTime = [params objectForKey:XN_MI_RP_INFO_DATESTR];
        pd.amountLimit = [[params objectForKey:XN_MI_PR_INFO_AMOUNTLIMIT] integerValue];
        pd.investAmount = [NSString stringWithFormat:@"%@",[params objectForKey:XN_MI_PR_INFO_AMOUNT]];
        pd.sendStatus = [params objectForKey:XN_MI_PR_INFO_SENDSTATUS];
        pd.amount = [params objectForKey:XN_MI_PR_INFO_AMOUNT];
        pd.name = [params objectForKey:@"name"];
        
        return pd;
    }
    return nil;
}
@end
