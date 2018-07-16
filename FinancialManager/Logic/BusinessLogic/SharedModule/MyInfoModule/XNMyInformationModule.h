//
//  MyInfoModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

#define XN_MYINFO_MYPROFIT_DETAIL_TYPE_DATA @"datas"
#define XN_INVEST_REDPACKET_COUNT @"useableRedPacketCount"
#define XN_INVEST_JOBGRADE_COUPON_COUNT @"useableJobGradeCouponCount"
#define XN_INVEST_ADDFEECOUPON_COUNT @"useableAddFeeCouponCount"
#define XN_DISPATCH_REDPACKET_COUNT @"sendRedPacketCount"
#define XN_MYINFO_MY_BUND @"fundAmount"
@class XNMIHomePageInfoMode,XNMIMyProfitMode,XNMIMyProfitTypeMode,XNMIMyProfitDetailStatisticMode,XNMIMyProfitDetailListMode,MIMySetMode,RedPacketListMode,XNCfgMsgListMode,XNInvitedListMode, MIAccountBalanceMode, MIAccountBalanceCommonMode, MIMonthProfixMode,XNPlatformUserCenterOrProductMode, MIAccountCenterMode,XNInvestPlatformMode,MyAccountBookDetailMode,MyAccountBookInvestListMode,MyAccountBookInvestItemMode,ComissionCouponListMode,LevelCouponListMode;
@interface XNMyInformationModule : AppModuleBase

@property (nonatomic, strong) XNMIHomePageInfoMode     * homePageMode;
@property (nonatomic, strong) NSString                 * bundAmount;//基金数据
@property (nonatomic, strong) XNInvestPlatformMode     * investPlatformMode;
@property (nonatomic, strong) XNMIMyProfitMode         * myProfitMode;
@property (nonatomic, strong) NSArray                  * myProfitTypeArray;
@property (nonatomic, strong) XNMIMyProfitDetailStatisticMode * myProfitDetailLisetStatisticMode;
@property (nonatomic, strong) XNMIMyProfitDetailListMode     * myProfitListMode;

@property (nonatomic, strong) MIMySetMode              * settingMode;

@property (nonatomic, strong) RedPacketListMode        * canUsedRedPacketListMode;
@property (nonatomic, strong) RedPacketListMode        * investRedPacketListMode;
@property (nonatomic, strong) ComissionCouponListMode  * comissionCouponListMode;
@property (nonatomic, strong) LevelCouponListMode      * levelCouponListMode;
@property (nonatomic, strong) NSString                 * redPacketCount;
@property (nonatomic, strong) NSString                 * levelCouponCount;
@property (nonatomic, strong) NSString                 * comissionCouponCount;

@property (nonatomic, strong) MIAccountBalanceMode *accountBalanceMode;
@property (nonatomic, strong) MIAccountBalanceCommonMode *monthProfitTotalListMode;

@property (nonatomic, strong) MIAccountBalanceCommonMode *monthProfitDetailListMode;
@property (nonatomic, strong) MIAccountBalanceCommonMode *waiGrantMonthProfitDetailListMode;
@property (nonatomic, strong) MIAccountBalanceCommonMode *grantMonthProfitDetailListMode;

@property (nonatomic, strong) MIMonthProfixMode *monthProfixMode;

@property (nonatomic, strong) XNPlatformUserCenterOrProductMode *platformProductMode;
@property (nonatomic, strong) XNPlatformUserCenterOrProductMode *platformUserCenterMode;
@property (nonatomic, assign) BOOL isExistForThirdOrg; //是否存在于第三方平台
@property (nonatomic, assign) BOOL isBindCurOrg; //用户是否已经绑定此机构

@property (nonatomic, strong) MIAccountCenterMode *accountCenterMode;

@property (nonatomic, strong) MyAccountBookDetailMode * accountBookDetailMode;
@property (nonatomic, strong) MyAccountBookInvestListMode * accountBookInvestListMode;
@property (nonatomic, strong) MyAccountBookInvestItemMode * accountBookInvestItemMode;

+ (instancetype)defaultModule;

/**
 * 获取首页数据
 **/
- (void)getMyInfoHomePageInfo;

/**
 * 获取我的基金
 **/
- (void)getMyBundInfo;

//获取我的投资平台
- (void)getMyInvestPlatform;

/**
 * 我的收益
 * params timeType 时间类型
 * params time 时间
 **/
- (void)getMyProfitInfoForTimeType:(NSString *)timeType time:(NSString *)timeStr;

/**
 * 我的收益-收益明细累计
 **/
- (void)getMyProfitDetailStatisticForTimeType:(NSString *)timeType time:(NSString *)time profitType:(NSString *)profitTypeId;

/**
 * 收益明细分页
 * params timeType 时间类型
 * params time 时间
 * params profitTypeId 收益类型
 * params pageIndex 页标
 * params pageSize 页大小
 **/
- (void)getMyProfitDetailListForTimeType:(NSString *)timeType time:(NSString *)time profitTypeId:(NSString *)typeId pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;

/**
 *   获取个人设置的状态
 **/
- (void)requestMySettingInfo;

/**
 * 获取优惠券数量
 **/
- (void)requestCouponCount;

/**
 * 可用红包列表
 * params deadLine
 * params mode
 * params platform
 * params productId
 * params type
 **/
- (void)requestCanUsedRedPacketWithDeadLine:(NSString *)deadLine model:(NSString *)mode platform:(NSString *)platform productId:(NSString *)productId type:(NSString *)type PageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;

/**
 *  红包列表
 **/
- (void)requestInvestRedPacketInfoWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;

/**
 *  加佣券列表
 **/
- (void)requestComissionCouponInfoWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;
/**
 * 职级列表
 **/
- (void)requestLevelCouponInfoWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;


/**
 *  派发红包-客户
 **/
- (void)dispatchRedPacketWithRedPacketRid:(NSString *)redPacketRid redPacketMoney:(NSString *)money usersMobile:(NSArray *)userMobilesArray;

/**
 * 派发红包-理财师
 **/
- (void)dispatchRedPacketForCfgWithRedPacketRid:(NSString *)redPacketRid usersMobile:(NSArray *)userMobiles;

/**
 * 账户余额
 **/
- (void)requestAccountBalance;

/**
 * 账户余额月份收益总计列表
 **/
- (void)requestMonthProfitTotalList:(NSString *)pageIndex pageSize:(NSString *)pageSize;

/**
 * 月度收益统计
 * params month 月份；例：2016-11
 **/
- (void)requestMonthProfitStatisticsWithMonth:(NSString *)month;

/**
 * 月度收益明细列表
 * params month 月份；例：2016-11
 * params pageIndex 页码
 * params pageSize 	页面记录数，默认为10
 * params profixType 收益类型 1销售佣金，2推荐津贴，3活动奖励，4团队leader奖励
 **/
- (void)requestMonthProfitDetailListWithMonth:(NSString *)month
                                    pageIndex:(NSString *)pageIndex
                                     pageSize:(NSString *)pageSize
                                   profixType:(NSString *)profixType;

/**
 * 是否存在于第三方平台
 * params orgNo 机构编码
 **/
- (void)isExistInPlatform:(NSString *)orgNo;

/**
 * 是否已绑定的机构
 * params orgNo 机构编码
 **/
- (void)isBindOrgAcct:(NSString *)orgNo;

/**
 * 绑定平台帐号
 * params orgNo 机构编码
 **/
- (void)bindPlatformAccount:(NSString *)orgNo;

/**
 * 绑定完成机构产品跳转地址
 * params orgNo 机构编码
 * params productId 产品id
 **/
- (void)requestOrgProductUrl:(NSString *)orgNo productId:(NSString *)productId;

/**
 * 绑定完成机构用户中心跳转地址
 * params orgNo 机构编码
 **/
- (void)requestPlatformUserCenterUrl:(NSString *)orgNo;

/**
 * 个人中心
 **/
- (void)requestAccountCenter;

/**
 * 记账本统计
 **/
- (void)requestAccountBookStatistics;

/**
 * 记账本投资列表
 * params pageIndex 页码
 * params pageSize 页大小
 **/
- (void)requestAccountBookInvestListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;

/**
 * 记账本详情
 * params detailId 详情id
 **/
- (void)requestAccountBookItemDetail:(NSString *)detailId;

/**
 * 记账本编辑
 * params detailId 详情id
 * params investAmt 投资本金
 * params direction 去向
 * params profit 收益
 * params remark 备注
 * params status 状态（true表示在投，false表示删除)
 **/
- (void)requestAccountBookEditWithDetailId:(NSString *)detailId investAmt:(NSString *)investAmt investDirection:(NSString *)direction profit:(NSString *)profit remark:(NSString *)remark status:(BOOL)status;
@end
