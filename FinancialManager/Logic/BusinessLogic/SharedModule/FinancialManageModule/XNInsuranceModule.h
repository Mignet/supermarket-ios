//
//  XNBundModule.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

@class XNInsuranceItem,XNInsuranceList,XNInsuranceDetailMode,XNInsuranceListLinkMode, InsuranceBannerModel, InsuranceSelectModel, XNInsuranceQquestionResultModel;

@interface XNInsuranceModule : AppModuleBase

@property (nonatomic, strong) XNInsuranceItem * selectedInsuranceItem;

/*** 平台保险 **/
@property (nonatomic, strong) XNInsuranceList * insuranceList;

/*** 甄选保险 **/
//@property (nonatomic, strong) NSMutableArray *insuranceSelectArr;

/*** 保险banner **/
@property (nonatomic, strong) InsuranceBannerModel *bannerModel;

/*** 甄选保险 **/
@property (nonatomic, strong) InsuranceSelectModel *insuranceSelectModel;

@property (nonatomic, strong) XNInsuranceDetailMode *insuranceDetailMode;

@property (nonatomic, strong) XNInsuranceListLinkMode * insuranceListLinkMode;

/*** 是否已经评测 **/
@property (nonatomic, strong) XNInsuranceQquestionResultModel *insuranceResultModel;

+ (instancetype)defaultModule;

/*
 * 精选保险
 **/
- (void)requestSelectedInsurance;

/**
 * 保险列表
 *
 * params pageIndex 
 * params pageSize 
 *
 **/
- (void)requestInsuranceListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize insuranceCategory:(NSString *)insuranceCategory;

/* 
 * 获取跳转参数
 * params caseCode 产品方案代码
 */
- (void)requestInsuranceDetaiParamsWithCaseCode:(NSString *)caseCode;

/**
 * 获取保单列表链接
 **/
- (void)requestInsuranceOrderListLink;

/**
 * 列表-甄选保险
 **/
- (void)request_insurance_qixin_insuranceSelect;

/**
 * 保险种类
 */
- (void)request_insurance_category;

/***
 * 保险banner
 */
- (void)request_insurance_banner;

/***
 *  保险评测接口 （/api/insurance/qixin/questionSummary）
 */
- (void)request_qixin_questionSummary:(NSMutableDictionary *)params;

/***
 * 首页-保险评测结果  /api/insurance/qixin/queryQquestionResult
 */
- (void)request_insurance_qixin_queryQquestionResult;

/***
 * 保险评测接口 /api/insurance/qixin/questionSummary
 */
- (void)request_insurance_qixin_questionSummaryParams:(NSDictionary *)params;


@end
