//
//  XCustomerServerModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/16.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

@class XNCSHomePageMode,CSInvestStatisticMode,CSInvestStatisticListMode,XNCSTradeListMode,XNCSCustomerStatisticsMode,XNCSMyCustomerListMode,XNCSCustomerDetailMode,XNCSMyCustomerTradeListMode,XNIMUserInfoMode, XNCSDeclarationListMode,CSCfgSaleMode,CSCfgSaleListMode,XNCSCustomerCfpMemberMode,XNCSNewCustomerModel,XNCSMyCustomerInvestRecordListMode,XNCSCfgDetailMode,ReturnMoneyListModel;
@interface XNCustomerServerModule : AppModuleBase


@property (nonatomic, strong) XNCSHomePageMode           * homePageMode;
@property (nonatomic, strong) CSInvestStatisticMode     * investStatisticMode;
@property (nonatomic, strong) CSInvestStatisticListMode * investRecordStatisticListMode;
@property (nonatomic, strong) CSInvestStatisticListMode * investPeopleStatisticListMode;

@property (nonatomic, strong) XNCSTradeListMode         * purchauseTradeListMode;
@property (nonatomic, strong) XNCSTradeListMode         * redomTradeListMode;
@property (nonatomic, strong) XNCSCustomerStatisticsMode* customerStatisticsMode;


@property (nonatomic, strong) XNCSMyCustomerListMode  * myCustomerListMode;
@property (nonatomic, strong) XNCSNewCustomerModel *    myNewCustomerModel;
@property (nonatomic, strong) XNCSCustomerCfpMemberMode * customerCfpMemberMode;
@property (nonatomic, strong) XNCSCustomerDetailMode  * customerDetailMode;
@property (nonatomic, strong) XNCSCfgDetailMode  * cfgDetailMode;

@property (nonatomic, strong) XNCSMyCustomerInvestRecordListMode * customerInvestRecordListMode;


@property (nonatomic, strong) XNCSMyCustomerTradeListMode * customerTradeRecordListMode;
@property (nonatomic, strong) XNCSMyCustomerTradeListMode * customerEndTimeRecordListMode;

@property (nonatomic, strong) XNCSDeclarationListMode *declarationListMode;

@property (nonatomic, strong) NSArray                 * imUserInfoArray;
@property (nonatomic, strong) NSDictionary            * expireRedeemDictionary;

@property (nonatomic, strong) NSArray * customerId;
@property (nonatomic, strong) NSArray *selectAgentArray;

@property (nonatomic, strong) CSCfgSaleMode *cfgSaleMode;
@property (nonatomic, strong) CSCfgSaleListMode *cfgSaleListMode;

@property (nonatomic, strong) ReturnMoneyListModel *waitReturnMoneyListModel;
@property (nonatomic, strong) ReturnMoneyListModel *yetReturnMoneyListModel;

@property (nonatomic, strong) ReturnMoneyListModel *dayWaitReturnMoneyListModel;
@property (nonatomic, strong) ReturnMoneyListModel *dayYetReturnMoneyListModel;

+ (instancetype)defaultModule;

/**
 * 获取客户服务首页
 * params date 指定日期
 **/
- (void)getCSHomePageData;

/**
 *  获取客户成员／理财师团队成员数据
 * params type 业务类型 1 理财师 2 客户
 **/
- (void)getCsCustomerCfpMemberWithType:(NSString *)type;

/**
 * 获取客户列表
 * params name 客户姓名、电话号码
 * params customerType 客户类型-1表示投资客户,2表示未投资客户，3表示重要客户，为空表示全部
 * params pageIndex 页标
 * params pageSize 页大小
 * params sort 排序字段1:投资额；2:注册时间3:投资时间；4:到期时间；5:姓名)
 * params order 排序方式: (1:降序，2:升序)
 **/
- (void)getCustomerListForCustomerName:(NSString *)name customerType:(NSString *)customerType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize sort:(NSString *)sort order:(NSString *)order;

/***
 * 获取客户列表 (4.5.0)
 **/
- (void)getNewCustomerListForCustomerType:(NSString *)customerType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize attenInvestType:(NSString *)attenInvestType nameOrMobile:(NSString *)nameOrMobile;

/**
 * 关注客户
 * params customerId 顾客id
 */
- (void)careCustomer:(NSString *)userId;

/**
 * 取消关注客户
 * params customerId 顾客id
 * params busType 1 理财师 2 客户
 */
- (void)cancelCaredCustomer:(NSString *)customerId;

/**
 * 关注理财师
 * params customerId 顾客id
 */
- (void)careCfg:(NSString *)userId;

/**
 * 取消关注客户
 * params customerId 顾客id
 * params busType 1 理财师 2 客户
 */
- (void)cancelCaredCfg:(NSString *)customerId;

/**
 * 客户详情
 * params userId 客户id
 **/
- (void)getCustomerDetailForCustomer:(NSString *)userId;

/**
 * 理财师详情
 * params userid 客户id
 **/
- (void)getCfgDetailForCfg:(NSString *)userId;

/**
 * 客户详情-投资记录
 * prams userId 顾客的用户id
 * params busType 业务类型 1理财师 2客户
 * params pageIndex 页码
 * params pageSize 页面大小
 **/
- (void)getCustomerInvestRecordListForUserId:(NSString *)userId type:(NSString *)busType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;

/**
 * 根据环信账号获取用户信息
 * params easemobAcct 环信账号
 **/
- (void)getUserInfoByEaseMob:(NSString *)easemobAcct;

/** 
 * 到期回款
 * params pageIndex 第几页
 * params pageSize 页面大小
 **/
- (void)getExpireRedeemWithCustomerId:(NSString *)customerId pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;


/***
 * 回款日历 (4.5.0)
 * params pageIndex 第几页
 * params pageSize  页面条数
 * params repamentTime  回款时间 （非必传）
 * praams repamentType  回款状态 （0-待回款 1-已回款 非必需 默认查所有）
 **/
- (void)loadWaitReturnMoneyListRepamentType:(NSString *)repamentType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize repamentTime:(NSString *)repamentTime;

- (void)loadYetReturnMoneyListRepamentType:(NSString *)repamentType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize repamentTime:(NSString *)repamentTime;


- (void)loadDayYetReturnMoneyListRepamentType:(NSString *)repamentType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize repamentTime:(NSString *)repamentTime;

- (void)loadDayWaitReturnMoneyListRepamentType:(NSString *)repamentType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize repamentTime:(NSString *)repamentTime;

/**
 * 报单列表
 * params pageIndex 第几页
 * params pageSize 页面大小
 **/
- (void)getDeclarationListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;

/**
 * 选择机构列表
 **/
//- (void)selectAgentList;

/**
 * 提交报单
 * params customerName 客户名称
 * params userMobile 客户手机
 * params agentNo 机构编号
 * params agentName 机构名称
 * params productName 产品名称
 * params buyMoney 购买金额
 * params investImage 截图图片
 * params
 **/
- (void)commitDeclarationWithCustomerName:(NSString *)name userMobile:(NSString *)mobile agentNo:(NSString *)agentNo agentName:(NSString *)agentName productName:(NSString *)productName buyMoney:(NSString *)buyMoney investImage:(NSString *)investImage investTime:(NSString *)investTime productDeadLineType:(NSString *)deadLineType productDeadLine:(NSString *)deadLine;


/**
 * 团队销售统计
 * date 日期格式: 周、日：2016-12-02；月份：2016-12
 * dateType 时间类别: 4日；5周；3月
 **/
- (void)teamSaleStatisticsWithDate:(NSString *)date dateType:(NSString *)dateType;


/**
 * 团队销售记录列表
 * date	日期格式: 周、日：2016-12-02；月份：2016-12
 * dateType 时间类别: 4日；5周；3月
 * pageIndex 第几页 >=1,默认为1
 * pageSize 页面记录数，默认为10
 **/
- (void)teamSaleListWithDate:(NSString *)date
                    dateType:(NSString *)dateType
                   pageIndex:(NSString *)pageIndex
                    pageSize:(NSString *)pageSize;
@end
