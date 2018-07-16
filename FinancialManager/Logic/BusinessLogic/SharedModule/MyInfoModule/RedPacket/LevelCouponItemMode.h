//
//  RedPacketInfoMode.h
//  FinancialManager
//
//  Created by xnkj on 6/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MI_RP_INFO_EXPIRESTIME @"expiresTime"
#define XN_MI_RP_INFO_STRTDATESTR @"useTime"
#define XN_MI_RP_INFO_SHOWSTATUS @"status"
#define XN_MI_RP_INFO_PLATFORMLIMIT @"applyPlatform"
#define XN_MI_RP_INFO_VOUCHERNAME @"voucherName"
#define XN_MI_RP_INFO_VOUCHERTYPE @"voucherType"

#define XN_MI_RP_INFO_ACTIVITYATTR @"activityAttr"
#define XN_MI_RP_INFO_JOBGRADEWELFARE1 @"jobGradeWelfare1"
#define XN_MI_RP_INFO_JOBGRADEWELFARE2 @"jobGradeWelfare2"


@interface LevelCouponItemMode : NSObject

@property (nonatomic, strong) NSString * activityAttr;//小兵快跑
@property (nonatomic, strong) NSString * applyPlatform; //限制平台 平台限制 =true 有效
@property (nonatomic, strong) NSString * expiresTime;
@property (nonatomic, strong) NSString * jobGradeWelfare1;
@property (nonatomic, strong) NSString * jobGradeWelfare2;
@property (nonatomic, assign) NSInteger  showStatus;//1：未过期 2：已使用 3：已过期 4:已失效
@property (nonatomic, strong) NSString * useTime;
@property (nonatomic, strong) NSString * voucherName;
@property (nonatomic, strong) NSString * voucherType; //30代表经理,40代表总监

+ (instancetype)initLevelCouponInfoWithParams:(NSDictionary *)params;
@end

