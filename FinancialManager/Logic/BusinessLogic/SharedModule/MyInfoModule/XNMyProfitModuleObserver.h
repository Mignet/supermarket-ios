//
//  XNMyProfitModuleObserver.h
//  FinancialManager
//
//  Created by xnkj on 22/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

@class XNMyProfitModule;
@protocol XNMyProfitModuleObserver <NSObject>
@optional

//获取我的收益列表
- (void)XNMyInfoModuleMyProfitListDidReceive:(XNMyProfitModule *)module;
- (void)XNMyInfoModuleMyProfitListDidFailed:(XNMyProfitModule *)module;

//资金明细－账户余额
- (void)XNMyProfitModuleAccountBalanceDetailDidReceive:(XNMyProfitModule *)module;
- (void)XNMyProfitModuleAccountBalanceDetailDidFailed:(XNMyProfitModule *)module;

//资金明细－收支明细
- (void)XNMyProfitModuleAccountBalanceDetailListDidReceive:(XNMyProfitModule *)module;
- (void)XNMyProfitModuleAccountBalanceDetailListDidFailed:(XNMyProfitModule *)module;

// 团队leader奖励-累计奖励
- (void)XNMyProfitModuleAccountLeaderRewardDidReceive:(XNMyProfitModule *)module;
- (void)XNMyProfitModuleAccountLeaderRewardDidFailed:(XNMyProfitModule *)module;

// 团队leader奖励-直属理财师团队
- (void)XNMyProfitModuleLeaderRewardDirectCfgListDidReceive:(XNMyProfitModule *)module;
- (void)XNMyProfitModuleLeaderRewardDirectCfgListDidFailed:(XNMyProfitModule *)module;

//团队leader奖励-成员贡献明细
- (void)XNMyProfitModuleLeaderRewardContributeListDidReceive:(XNMyProfitModule *)module;
- (void)XNMyProfitModuleLeaderRewardContributeListDidFailed:(XNMyProfitModule *)module;

//我的投资记录
- (void)XNMyProfitModuleInvestRecordListDidReceive:(XNMyProfitModule *)module;
- (void)XNMyProfitModuleInvestRecordListDidFailed:(XNMyProfitModule *)module;

//投资记录
- (void)requestInvestRecordListDidReceive:(XNMyProfitModule *)module;
- (void)requestInvestRecordListDidFailed:(XNMyProfitModule *)module;

// 投资记录 （具体某一天）
- (void)requestDayInvestRecordListDidReceive:(XNMyProfitModule *)module;
- (void)requestDayInvestRecordListDidFailed:(XNMyProfitModule *)module;

// 保险记录
- (void)requestInsuranceRecordListDidReceive:(XNMyProfitModule *)module;
- (void)requestInsuranceRecordListDidFailed:(XNMyProfitModule *)module;

// 保险记录 （具体某一天）
- (void)requestDayInsuranceRecordListDidReceive:(XNMyProfitModule *)module;
- (void)requestDayInsuranceRecordListDidFailed:(XNMyProfitModule *)module;

@end
