//
//  XNNewComissionCouponMode.h
//  FinancialManager
//
//  Created by xnkj on 23/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_NEW_LEVELCOUPON_DICTIONARY @"XN_NEW_LEVELCOUPON_DICTIONARY"
#define XN_NEW_LEVELCOUPON_TYPE @"jobGrade"
#define XN_NEW_LEVELCOUPON_HASNEWADDFEECOUPON @"haveNewJobGrade"

@interface XNNewLevelCouponMode : NSObject

@property (nonatomic, strong) NSString * jobGrade; //职级
@property (nonatomic, assign) BOOL haveNewJobGrade;//是否有新的加佣券，0没有1有

+ (instancetype)initLevelCouponWithParams:(NSDictionary *)params;
@end
