//
//  RedPacketInfoMode.m
//  FinancialManager
//
//  Created by xnkj on 6/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "ComissionCouponItemMode.h"

@implementation ComissionCouponItemMode

+ (instancetype)initRedPacketInfoWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        ComissionCouponItemMode * pd = [[ComissionCouponItemMode alloc]init];
        
        pd.couponId = [params objectForKey:XN_MI_RP_INFO_COUPONID];
        pd.investLimit = [[params objectForKey:XN_MI_RP_INFO_INVEST_LIMIT] boolValue];
        pd.platform = [params objectForKey:XN_MI_RP_INFO_PLATFORMNAME];
        pd.isPlatformLimit = [[params objectForKey:XN_MI_RP_INFO_PLATFORMLIMIT] boolValue];
        pd.rate = [NSString stringWithFormat:@"%@",[params objectForKey:XN_MI_RP_INFO_RATE]];
        pd.showStatus = [[params objectForKey:XN_MI_RP_INFO_SHOWSTATUS] integerValue];
        pd.titleName = [params objectForKey:XN_MI_RP_INFO_TITLENAME];
        pd.type = [[params objectForKey:XN_MI_RP_INFO_TYPE] integerValue];
        pd.validBeginTime = [params objectForKey:XN_MI_RP_INFO_STRTDATESTR];
        pd.validEndTime = [params objectForKey:XN_MI_RP_INFO_DATESTR];
        
        return pd;
    }
    return nil;
}
@end
