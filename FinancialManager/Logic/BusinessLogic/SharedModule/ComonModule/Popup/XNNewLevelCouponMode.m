//
//  XNNewComissionCouponMode.m
//  FinancialManager
//
//  Created by xnkj on 23/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNNewLevelCouponMode.h"

@implementation XNNewLevelCouponMode

+ (instancetype)initLevelCouponWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        [_LOGIC saveNSDictionary:params key:XN_NEW_LEVELCOUPON_DICTIONARY];
        
        XNNewLevelCouponMode * pd = [[XNNewLevelCouponMode alloc]init];
        
        pd.jobGrade = [params objectForKey:XN_NEW_LEVELCOUPON_TYPE];
        pd.haveNewJobGrade = [[params objectForKey:XN_NEW_LEVELCOUPON_HASNEWADDFEECOUPON] boolValue];
        
        return pd;
    }
    return nil;
}
@end
