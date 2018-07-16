//
//  XNMessageModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

#define XN_HOME_IS_NEW_USER @"isNew"
#define XN_HOME_HAS_NEWREDPACKET @"hasNewRedPacket"

@class XNUpgradeMode,XNConfigMode,XNHomeBannerMode,XNRemindPopMode,XNNewComissionCouponMode,XNComissionNewRecordMode,XNNewLevelCouponMode;
@interface XNCommonModule : AppModuleBase

@property (nonatomic, strong) XNUpgradeMode * upgradeMode;
@property (nonatomic, strong) XNConfigMode  * configMode;
@property (nonatomic, strong) NSArray * platformBannerListArray;
@property (nonatomic, strong) NSArray * platformBannerImgUrlListArray;
@property (nonatomic, strong) NSArray * platformBannerLinkUrlListArray;

@property (nonatomic, strong) NSArray * productBannerListArray;
@property (nonatomic, strong) NSArray * productBannerImgUrlListArray;
@property (nonatomic, strong) NSArray * productBannerLinkUrlListArray;

@property (nonatomic, strong) NSString *shortTermProductImageUrl;
@property (nonatomic, strong) NSString *longTermProductImageUrl;

@property (nonatomic, strong) XNHomeBannerMode *homePopAdvMode;

@property (nonatomic, assign) BOOL  isNewUser;

@property (nonatomic, strong) XNRemindPopMode * remindPopMode;

@property (nonatomic, strong) XNNewComissionCouponMode * hasNewcomissionCouponMode;
@property (nonatomic, assign) BOOL                       hasNewRedPacket;
@property (nonatomic, strong) XNComissionNewRecordMode  * hasNewComissionCouponRecordMode;
@property (nonatomic, strong) XNNewLevelCouponMode      * levelCouponMode;

+ (instancetype)defaultModule;

/**
 *  查看app是否需要升级
 * */
- (void)checkAppUpgrade;

/**
 *  获取配置信息
 **/
- (void)requestConfigInfo;

/**
 * 获取bug列表
 **/
- (void)userGetPatch;

/**
 * 广告查询
 * params advPlacement 广告位置描述 (平台banner:platform_banner,产品banner:product_banner)
 **/
- (void)requestBannerWithAdvPlacement:(NSString *)advPlacement;

//banner列表转化处理
- (void)convertBannerMode:(NSDictionary *)dic advPlacement:(NSString *)advPlacement;

/**
 * 首页产品弹出窗
 **/
- (void)requestHomeWithPopAdv;

/**
 * 获取提示信息
 **/
- (void)requestHomeRemindInfo;

/**
 *首页-是否有新的加佣券
 **/
 - (void)requestHomeNewComissionCoupon;
/**
 *首页-是否有新的红包
 **/
- (void)requestHomeNewRedPacket;

/**
 *佣金券是否有新的使用记录
 **/
- (void)requestHomeComissionHasNewRecord;

/**
 * 是否有新的职级体验券
 **/
- (void)requestNewLeveCoupon;


/***
 * 系统所有参数配置
 */
- (void)request_App_SysConfig_ConfigKey:(NSString *)configKey configType:(NSString *)configType;



@end
