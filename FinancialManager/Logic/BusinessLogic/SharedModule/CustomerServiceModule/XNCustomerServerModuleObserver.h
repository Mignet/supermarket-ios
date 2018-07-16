//
//  XCustomerServerModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/16.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

@class XNCustomerServerModule;
@protocol XNCustomerServerModuleObserver <NSObject>
@optional

//获取首页数据
- (void)XNCustomerServerModuleGetHomePageDataDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServermoduleGetHomePageDataDidFailed:(XNCustomerServerModule *)module;

//投资统计
- (void)XNCustomerServerModuleInvestStatisticDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleInvestStatisticDidFailed:(XNCustomerServerModule *)module;

//投资统计列表-投资记录
- (void)XNCustomerServerModuleInvestRecordStatisticListDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleInvestRecordStatisticListDidFailed:(XNCustomerServerModule *)module;

//投资统计列表-投资人数
- (void)XNCustomerServerModuleInvestPeopleStatisticListDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleInvestPeopleStatisticListDidFailed:(XNCustomerServerModule *)module;

//获取交易列表-申购
- (void)XNCustomerServerModulePurchauseTradeListDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModulePurchauseTradeListDidFailed:(XNCustomerServerModule *)module;

//获取交易列表-赎回
- (void)XNCustomerServerModuleRedomTradeListDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleRedomTradeListDidFailed:(XNCustomerServerModule *)module;

//客户列表-统计
- (void)XNCustomerServerModuleCustomerCfpMemberDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleCustomerCfpMemberDidFailed:(XNCustomerServerModule *)module;

//获取客户列表
- (void)XNCustomerServerModuleCustomerListDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleCustomerListDidFailed:(XNCustomerServerModule *)module;

//获取客户列表4.5.0
- (void)XNCustomerServerModuleNewCustomerListDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleNewCustomerListDidFailed:(XNCustomerServerModule *)module;

//邀请重要客户
- (void)XNCustomerServerModuleAddImprotantCustomerDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleAddImprotantCustomerDidFailed:(XNCustomerServerModule *)module;

//移除重要客户
- (void)XNCustomerServerModuleRemoveImprotantCustomerDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleRemoveImprotantCustomerDidFailed:(XNCustomerServerModule *)module;

//邀请重要客户
- (void)XNCustomerServerModuleCaredCfgDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleCaredCfgDidFailed:(XNCustomerServerModule *)module;

//移除重要客户
- (void)XNCustomerServerModuleCancelCaredCfgDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleCancelCaredCfgDidFailed:(XNCustomerServerModule *)module;

//顾客详情
- (void)XNCustomerServerModuleCustomerDetailDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleCustomerDetailDidFailed:(XNCustomerServerModule *)module;

//顾客详情
- (void)XNCustomerServerModuleCfgDetailDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleCfgDetailDidFailed:(XNCustomerServerModule *)module;

//获取交易记录
- (void)XNCustomerServerModuleCustomerTradeRecordListDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleCustomerTradeRecordListDidFailed:(XNCustomerServerModule *)module;

//获取客户详情投资记录
- (void)XNCustomerServerModuleCustomerInvestRecordListDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleCustomerInvestRecordListDidFailed:(XNCustomerServerModule *)module;

//获取记录
- (void)XNCustomerServerModuleCustomerEndTimeRecordListDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleCustomerEndTimeRecordListDidFailed:(XNCustomerServerModule *)module;

//根据环信账号获取用户信息
- (void)XNCustomerServerModuleGetUesrInfoByEasemobDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleGetUserInfoByEasemobDidFailed:(XNCustomerServerModule *)module;

//到期赎回列表
- (void)XNCustomerServerModuleGetExpireRedeemListDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleGetExpireRedeemListDidFailed:(XNCustomerServerModule *)module;

//获取报单列表
- (void)XNCustomerServerModuleDeclarationListDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleDeclarationListDidFailed:(XNCustomerServerModule *)module;

//选择机构列表
- (void)XNCustomerServerModuleSelectAgentListDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleSelectAgentListDidFailed:(XNCustomerServerModule *)module;

//提交报单
- (void)XNCustomerServerModuleCommitDeclarationDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleCommitDeclarationDidFailed:(XNCustomerServerModule *)module;

//团队销售统计
- (void)XNCustomerServerModuleTeamSaleStatisticsDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleTeamSaleStatisticsDidFailed:(XNCustomerServerModule *)module;

//团队销售记录列表
- (void)XNCustomerServerModuleTeamSaleListDidReceive:(XNCustomerServerModule *)module;
- (void)XNCustomerServerModuleTeamSaleListDidFailed:(XNCustomerServerModule *)module;

//获取待回款日历
- (void)loadWaitReturnMoneyListDidReceive:(XNCustomerServerModule *)module;
- (void)loadWaitReturnMoneyListDidFailed:(XNCustomerServerModule *)module;

//获取待回款日历 (确定日期)
- (void)loadDayWaitReturnMoneyListDidReceive:(XNCustomerServerModule *)module;
- (void)loadDayWaitReturnMoneyListDidFailed:(XNCustomerServerModule *)module;


//获取已回款日历
- (void)loadYetReturnMoneyListDidReceive:(XNCustomerServerModule *)module;
- (void)loadYetReturnMoneyListDidFailed:(XNCustomerServerModule *)module;


//获取已回款日历 (确定日期)
- (void)loadDayYetReturnMoneyListDidReceive:(XNCustomerServerModule *)module;
- (void)loadDayYetReturnMoneyListDidFailed:(XNCustomerServerModule *)module;


@end
