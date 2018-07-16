//
//  RedPacketInfoMode.m
//  FinancialManager
//
//  Created by xnkj on 6/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "LevelCouponItemMode.h"

@implementation LevelCouponItemMode

+ (instancetype)initLevelCouponInfoWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        LevelCouponItemMode * pd = [[LevelCouponItemMode alloc]init];
        
        pd.activityAttr = [params objectForKey:XN_MI_RP_INFO_ACTIVITYATTR];
        pd.applyPlatform = [params objectForKey:XN_MI_RP_INFO_PLATFORMLIMIT];
        pd.expiresTime = [params objectForKey:XN_MI_RP_INFO_EXPIRESTIME];
        pd.useTime = [params objectForKey:XN_MI_RP_INFO_STRTDATESTR];
        pd.jobGradeWelfare1 = [params objectForKey:XN_MI_RP_INFO_JOBGRADEWELFARE1];
        pd.jobGradeWelfare2 = [params objectForKey:XN_MI_RP_INFO_JOBGRADEWELFARE2];
        pd.showStatus = [[params objectForKey:XN_MI_RP_INFO_SHOWSTATUS] integerValue];
        pd.voucherName = [params objectForKey:XN_MI_RP_INFO_VOUCHERNAME];
        pd.voucherType = [params objectForKey:XN_MI_RP_INFO_VOUCHERTYPE];
        
        return pd;
    }
    return nil;
}
@end
