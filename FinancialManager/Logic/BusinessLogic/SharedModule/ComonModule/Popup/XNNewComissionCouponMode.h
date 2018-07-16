//
//  XNNewComissionCouponMode.h
//  FinancialManager
//
//  Created by xnkj on 23/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_HOME_COMISSION_COUPON_DICTIONARY @"XN_HOME_COMISSION_COUPON_DICTIONARY"
#define XN_HOME_COMISSION_ADDFEECOUPONUSEDETAIL @"addFeeCoupon"
#define XN_NEW_COMISSIONCOUPON_RATE @"rate"
#define XN_NEW_COMISSIONCOUPON_TYPE @"type"
#define XN_NEW_COMISSIONCOUPON_HASNEWADDFEECOUPON @"hasNewAddFeeCoupon"

@interface XNNewComissionCouponMode : NSObject

@property (nonatomic, strong) NSString * comissionRate; //加佣比例
@property (nonatomic, strong) NSString * type;//1.加佣券，2.奖励券
@property (nonatomic, assign) BOOL hasNewFeeCoupon;//是否有新的加佣券，0没有1有

+ (instancetype)initComissionCouponWithParams:(NSDictionary *)params;
@end
