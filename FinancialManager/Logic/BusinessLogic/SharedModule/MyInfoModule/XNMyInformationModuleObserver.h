//
//  MyInfoModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

@class XNMyInformationModule;
@protocol XNMyInformationModuleObserver <NSObject>
@optional

//获取首页数据
- (void)XNMyInfoModuleGetHomePageDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleGetHomePageDidFailed:(XNMyInformationModule *)module;

//获取我的基金
- (void)XNMyInfoModuleGetMyBundDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleGetMyBundDidFailed:(XNMyInformationModule *)module;

//获取我的投资平台
- (void)XNMyInfoModuleGetInvestPlatformDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleGetInvestPlatformDidFailed:(XNMyInformationModule *)module;

//获取我的收益
- (void)XNMyInfoModuleMyProfitDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleMyProfitDidFailed:(XNMyInformationModule *)module;

//获取我的收益类型
- (void)XNMyInfoModuleMyProfitTypeDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleMyProfitTypeDidFailed:(XNMyInformationModule *)module;

//我的收益-详细累计
- (void)XNMyInfoModuleMyProfitDetailListStatisticDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleMyProfitDetailListStatisticDidFailed:(XNMyInformationModule *)module;

//获取我的收益列表
- (void)XNMyInfoModuleMyProfitListDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleMyProfitListDidFailed:(XNMyInformationModule *)module;

//个人设置
- (void)XNMyInfoModulePeopleSettingDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModulePeopleSettingDidFailed:(XNMyInformationModule *)module;

//可用红包
- (void)XNMyInfoModuleCanUsedRedPacketInfoDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleCanUsedRedPacketInfoDidFailed:(XNMyInformationModule *)module;

//投资红包
- (void)XNMyInfoModuleInvestRedPacketInfoDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleInvestRedPacketInfoDidFailed:(XNMyInformationModule *)module;

//加佣券
- (void)XNMyInfoModuleCouponCountDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleCouponCountDidFailed:(XNMyInformationModule *)module;

//职级体验券
- (void)XNMyInfoModuleLevelCouponDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleLevelCouponDidFailed:(XNMyInformationModule *)module;

//派发红包
- (void)XNMyInfoModuleDispatchRedPacketInfoDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleDispatchRedPacketInfoDidFailed:(XNMyInformationModule *)module;

//派发红包-理财师
- (void)XNMyInfoModuleCfgDispatchRedPacketInfoDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleCfgDispatchRedPacketInfoDidFailed:(XNMyInformationModule *)module;

//账户余额
- (void)XNMyInfoModuleAccountBalanceDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleAccountBalanceDidFailed:(XNMyInformationModule *)module;

//账户余额月份收益总计列表
- (void)XNMyInfoModuleMonthProfitTotalListDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleMonthProfitTotalListDidFailed:(XNMyInformationModule *)module;

//月度收益统计
- (void)XNMyInfoModuleMonthProfitStatisticsDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleMonthProfitStatisticsDidFailed:(XNMyInformationModule *)module;

//月度收益明细列表
- (void)XNMyInfoModuleMonthProfitDetailListDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleMonthProfitDetailListDidFailed:(XNMyInformationModule *)module;

//是否存在于第三方平台
- (void)XNMyInfoModuleIsExistInPlatformDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleIsExistInPlatformDidFailed:(XNMyInformationModule *)module;

//是否已绑定的机构
- (void)XNMyInfoModuleIsBindOrgAcctDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleIsBindOrgAcctDidFailed:(XNMyInformationModule *)module;

//绑定平台帐号
- (void)XNMyInfoModuleBindPlatformAccountDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleBindPlatformAccountDidFailed:(XNMyInformationModule *)module;

//绑定完成机构－用户中心跳转地址
- (void)XNMyInfoModulePlatformUserCenterUrlDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModulePlatformUserCenterUrlDidFailed:(XNMyInformationModule *)module;

//绑定完成机构-产品跳转地址
- (void)XNMyInfoModulePlatformProductUrlDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModulePlatformProductUrlDidFailed:(XNMyInformationModule *)module;

//个人中心
- (void)XNMyInfoModuleAccountCenterDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleAccountCenterDidFailed:(XNMyInformationModule *)module;

//记账本统计
- (void)XNMyInfoModuleAccountBookDetailDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleAccountBookDetailDidFailed:(XNMyInformationModule *)module;

//记账本投资列表
- (void)XNMyInfoModuleAccountBookInvestListDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleAccountBookInvestListDidFailed:(XNMyInformationModule *)module;

//记账本详情
- (void)XNMyInfoModuleAccountBookInvestDetailDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleAccountBookInvestDetailDidFailed:(XNMyInformationModule *)module;

//记账本详情
- (void)XNMyInfoModuleAccountBookEditDidReceive:(XNMyInformationModule *)module;
- (void)XNMyInfoModuleAccountBookEditDidFailed:(XNMyInformationModule *)module;
@end
