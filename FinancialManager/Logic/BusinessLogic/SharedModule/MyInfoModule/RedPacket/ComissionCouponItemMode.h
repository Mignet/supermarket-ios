//
//  RedPacketInfoMode.h
//  FinancialManager
//
//  Created by xnkj on 6/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MI_RP_INFO_DATESTR @"validEndTime"
#define XN_MI_RP_INFO_STRTDATESTR @"validBeginTime"
#define XN_MI_RP_INFO_TYPE @"type"
#define XN_MI_RP_INFO_TITLENAME @"source"
#define XN_MI_RP_INFO_SHOWSTATUS @"showStatus"
#define XN_MI_RP_INFO_RATE @"rate"
#define XN_MI_RP_INFO_PLATFORMLIMIT @"platformLimit"
#define XN_MI_RP_INFO_PLATFORMNAME @"platformName"
#define XN_MI_RP_INFO_INVEST_LIMIT @"investLimit"
#define XN_MI_RP_INFO_COUPONID @"couponId"

@interface ComissionCouponItemMode : NSObject

@property (nonatomic, strong) NSString * validEndTime;
@property (nonatomic, strong) NSString * validBeginTime;
@property (nonatomic, assign) NSInteger type; //加拥券类型 1=加拥券|2=奖励券
@property (nonatomic, strong) NSString * titleName;
@property (nonatomic, assign) NSInteger showStatus;//1：未过期 2：已过期 3：已使用
@property (nonatomic, strong) NSString * rate;//加佣值
@property (nonatomic, assign) BOOL isPlatformLimit; //平台限制 true=限制|false=不限制
@property (nonatomic, strong) NSString *platform; //限制平台 平台限制 =true 有效
@property (nonatomic, assign) NSInteger investLimit; //投资限制 0=不限|1=用户首投|2=平台首投
@property (nonatomic, strong) NSString * couponId; //加佣券编号

+ (instancetype)initRedPacketInfoWithParams:(NSDictionary *)params;
@end

