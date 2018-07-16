//
//  XNMyProfitModule.h
//  FinancialManager
//
//  Created by xnkj on 22/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

@class XNMIMyProfitDetailListMode, MIAccountBalanceDetailMode, MIAccountBalanceCommonMode, XNMILeaderRewardMode, XNMIMyTeamListMode, MIInvestRecordListMode;
@interface XNMyProfitModule : AppModuleBase

@property (nonatomic, strong) XNMIMyProfitDetailListMode     * myProfitListMode;
@property (nonatomic, strong) MIAccountBalanceDetailMode *accountBalanceDetailMode;
@property (nonatomic, strong) MIAccountBalanceCommonMode *accountBalanceDetailListMode;
@property (nonatomic, strong) MIAccountBalanceCommonMode *totalDetailListMode;
@property (nonatomic, strong) MIAccountBalanceCommonMode *incomeDetailListMode;
@property (nonatomic, strong) MIAccountBalanceCommonMode *outDetailListMode;

@property (nonatomic, strong) XNMILeaderRewardMode *leaderRewardMode;
@property (nonatomic, strong) XNMIMyTeamListMode *leaderRewardDirectCfgMode;
@property (nonatomic, strong) XNMIMyTeamListMode *leaderRewardContributeMode;

@property (nonatomic, strong) MIInvestRecordListMode *investingProductsListMode;
@property (nonatomic, strong) MIInvestRecordListMode *expiredProductsListMode;

@property (nonatomic, strong) MIInvestRecordListMode *investRecordListMode;
@property (nonatomic, strong) MIInvestRecordListMode *dayInvestRecordListMode;

@property (nonatomic, strong) MIInvestRecordListMode *insuranceRecordListMode;
@property (nonatomic, strong) MIInvestRecordListMode *dayInsuranceRecordListMode;


+ (instancetype)defaultModule;

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
 * 资金明细－账户余额
 *
 **/
- (void)getAccountBalanceDetail;

/**
 * 资金明细－收支明细
 * params pageIndex 页码
 * params pageSize 页面大小
 * params typeValue 收支类型(0=全部1=收入|2=支出)
 **/
- (void)getAccountBalanceDetailList:(NSString *)pageIndex pageSize:(NSString *)pageSize typeValue:(NSString *)typeValue;

/**
 * 我的投资记录
 * params investType 投资记录类型(0-在投产品 1-已到期产品)
 * params pageIndex 第几页 >=1,默认为1
 * params pageSize 页面记录数，默认为10
 **/

- (void)getInvestRecordList:(NSString *)investType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;


/***
 * 接口名称 4.5.0 交易记录
 * params pageIndex 第几页 >=1,默认为1
 * params pageSize 页面记录数，默认为10
 * params investTime 非必需 YYYY-mm-dd
 **/
- (void)requestInvestRecordListPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize investTime:(NSString *)investTime;

// 接口名称 4.5.0 交易记录 (具体某一天)
- (void)requestDayInvestRecordListPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize investTime:(NSString *)investTime;


#pragma mark - 保险记录（4.5.1）
- (void)requestInsuranceRecordListPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize investTime:(NSString *)investTime;

#pragma mark - 保险记录 (4.5.1) 具体某一天
- (void)requestDayInsuranceRecordListPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize investTime:(NSString *)investTime;


@end
