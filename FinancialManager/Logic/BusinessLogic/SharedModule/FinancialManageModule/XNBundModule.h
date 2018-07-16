//
//  XNBundModule.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

@class XNBundListMode, XNBundThirdPageMode , XNMyBundHoldingStatisticMode, XNMyBundHoldingDetailMode;
@interface XNBundModule : AppModuleBase

@property (nonatomic, strong) XNBundListMode *hotBundListMode; //精选基金
@property (nonatomic, assign) BOOL isRegisterBund;
@property (nonatomic, strong) NSString *bundAccountNumber; //益丰账号
@property (nonatomic, strong) XNBundThirdPageMode *bundThirdPageMode;
@property (nonatomic, strong) XNBundThirdPageMode *bundThirdAccountMode;
@property (nonatomic, strong) XNBundListMode *bundListMode; //基金列表
@property (nonatomic, strong) XNMyBundHoldingStatisticMode *myBundHoldingStatisticMode;
//@property (nonatomic, strong) XNMyBundHoldingDetailMode *myBundHoldingDetailMode;
@property (nonatomic, strong) NSMutableArray *myBundHoldingArray;
@property (nonatomic, strong) XNBundListMode *myBundRecordingMode;

+ (instancetype)defaultModule;

/**
 * 精选基金
 **/
- (void)requestHotBundList;

/**
 * 奕丰基金是否注册
 **/
- (void)isRegisterBundResult;

/**
 * 奕丰基金注册
 **/
- (void)registerBund;

/**
 * 奕丰基金详情页跳转
 * param productCode 基金代码
 **/
- (void)gotoFundDetail:(NSString *)productCode;

/**
 * 奕丰基金个人资产页跳转
 **/
- (void)gotoFundAccount;

/**
 * 基金列表
 * params fundCodes 基金代码
 * params fundHouseCode 基金公司代码
 * params fundType 基金类型搜索
 * params geographicalSector 地理分类搜索
 * params isBuyEnable 是否可以购买
 * params isMMFund 是否是货币基金
 * params isQDII 是否是QDII基金
 * params isRecommended 是否是推荐基金
 * params pageIndex 页码
 * params pageSize 每页记录数
 * params period 排序字段
 * params queryCodeOrName 查询基金代码或者名称
 * params shortName 基金简称搜索
 * params sort 	排序方式
 * params specializeSector 行业分类搜索
 * params
 * params
 **/
- (void)requestBundListWithFundCodes:(NSString *)fundCodes
                       fundHouseCode:(NSString *)fundHouseCode
                            fundType:(NSString *)fundType
                  geographicalSector:(NSString *)geographicalSector
                         isBuyEnable:(NSString *)isBuyEnable
                            isMMFund:(NSString *)isMMFund
                              isQDII:(NSString *)isQDII
                       isRecommended:(NSString *)isRecommended
                           pageIndex:(NSString *)pageIndex
                            pageSize:(NSString *)pageSize
                              period:(NSString *)period
                     queryCodeOrName:(NSString *)queryCodeOrName
                           shortName:(NSString *)shortName
                                sort:(NSString *)sort
                    specializeSector:(NSString *)specializeSector;

/**
 * 基金类型选择
 **/
- (void)requestBundTypeSelector;

/**
 * 我的基金-持有资产
 **/
- (void)requestMyBundHoldingStatistic;

/**
 * 我的基金-持有明细
 * params fundCode 基金代码-非必需 过滤返回属于该基金代码的持有情况
 * params portfolioId 用户的投资组合编码-非必需 过滤返回属于该组合编码下的基金持有情况
 **/
- (void)requestMyFundHoldingDetail:(NSString *)fundCode portfolioId:(NSString *)portfolioId;

/**
 * 基金投资记录
 * params fundCodes 	基金代码
 * params merchantNumber 要查询的订单流水编号
 * params orderDateEnd 查询结束的下单日期
 * params orderDateStart 查询起始的下单日期
 * params pageIndex 	页码
 * params pageSize 每页记录数
 * params portfolioId 组合编码
 * params rspId 定投计划代码
 * params transactionStatus 	交易状态
 * params transactionType 	交易类型
 **/
- (void)requestMyFundRecordingWithFundCodes:(NSString *)fundCodes
                             merchantNumber:(NSString *)merchantNumber
                               orderDateEnd:(NSString *)orderDateEnd
                             orderDateStart:(NSString *)orderDateStart
                                  pageIndex:(NSString *)pageIndex
                                   pageSize:(NSString *)pageSize
                                portfolioId:(NSString *)portfolioId
                                      rspId:(NSString *)rspId
                          transactionStatus:(NSString *)transactionStatus
                            transactionType:(NSString *)transactionType;

@end
