//
//  XNNewComissionCouponMode.m
//  FinancialManager
//
//  Created by xnkj on 23/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNNewComissionCouponMode.h"

@implementation XNNewComissionCouponMode

+ (instancetype)initComissionCouponWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        [_LOGIC saveNSDictionary:params key:XN_HOME_COMISSION_COUPON_DICTIONARY];
        
        XNNewComissionCouponMode * pd = [[XNNewComissionCouponMode alloc]init];
            
        pd.comissionRate = [NSString stringWithFormat:@"%@",[[params objectForKey:XN_HOME_COMISSION_ADDFEECOUPONUSEDETAIL] objectForKey:XN_NEW_COMISSIONCOUPON_RATE]];
        pd.type = [NSString stringWithFormat:@"%@",[[params objectForKey:XN_HOME_COMISSION_ADDFEECOUPONUSEDETAIL] objectForKey:XN_NEW_COMISSIONCOUPON_TYPE]];
        
        pd.hasNewFeeCoupon = [[params objectForKey:XN_NEW_COMISSIONCOUPON_HASNEWADDFEECOUPON] boolValue];
        
        return pd;
    }
    return nil;
}
@end
