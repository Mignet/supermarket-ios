//
//  XNMessageModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

@class XNCommonModule;
@protocol XNCommonModuleObserver <NSObject>
@optional

//升级信息
- (void)XNCommonModuleUpgradeDidReceive:(XNCommonModule *)module;
- (void)XNCommonModuleUpgradeDidFailed:(XNCommonModule *)module;

//公共配置信息
- (void)XNCommonModuleConfigDidReceive:(XNCommonModule *)module;
- (void)XNCommonModuleConfigDidFailed:(XNCommonModule *)module;

//获取bug补丁
- (void)XNUserModuleGetBugCodeDidReceive:(XNCommonModule *)module;
- (void)XNUserModuleGetBugCodeDidFailed:(XNCommonModule *)module;

//广告查询
- (void)XNCommonModuleBannerDidReceive:(XNCommonModule *)module;
- (void)XNCommonModuleBannerDidFailed:(XNCommonModule *)module;

//首页产品弹出窗
- (void)XNCommonModuleHomePopAdvDidReceive:(XNCommonModule *)module;
- (void)XNCommonModuleHomePopAdvDidFailed:(XNCommonModule *)module;

//是否是新用户
- (void)XNCommonModuleIsNewUserDidReceive:(XNCommonModule *)module;
- (void)XNCommonModuleIsNewUserDidFailed:(XNCommonModule *)module;

//弹出提示
- (void)XNCommonModuleRemindPopDidReceive:(XNCommonModule *)module;
- (void)XNCommonModuleRemindPopDidFailed:(XNCommonModule *)module;

//是否有新的加佣券
- (void)XNCommonModuleNewComissionCouponDidReceive:(XNCommonModule *)module;
- (void)XNCommonModuleNewComissionCouponDidFailed:(XNCommonModule *)module;

//是否有新红包
- (void)XNCommonModuleNewRedPacketDidReceive:(XNCommonModule *)module;
- (void)XNCommonModuleNewRedPacketDidFailed:(XNCommonModule *)module;

//是否有新的加佣券记录
- (void)XNCommonModuleNewCouponRecordDidReceive:(XNCommonModule *)module;
- (void)XNCommonModuleNewCouponRecordDidFailed:(XNCommonModule *)module;

//是否有新的职级体验券
- (void)XNCommonModuleNewLevelCouponRecordDidReceive:(XNCommonModule *)module;
- (void)XNCommonModuleNewLevelCouponRecordDidFailed:(XNCommonModule *)module;
@end
