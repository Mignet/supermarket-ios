//
//  XNFinancialProductModule.h
//  FinancialManager
//
//  Created by xnkj on 20/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

#define XNFMPRODUCTTYPELISTDATA         @"datas"
#define XNFMPRODUCTSELECTEDCOUNT        @"count"
#define XNFMBATCHINVITEDTOREVIEWCONTENT @"content"
#define XNSHAREDCONTENT @"shareContent"

@class XNFMProductCategoryListMode, XNRecommendListMode;
@interface XNFinancialProductModule : AppModuleBase

@property (nonatomic, strong) XNFMProductCategoryListMode * productListMode;
@property (nonatomic, strong) NSString * selectedConditionProductCount;
@property (nonatomic, strong) NSDictionary                * productSharedMode;
@property (nonatomic, strong) XNRecommendListMode *recommendProductListMode;
@property (nonatomic, strong) XNRecommendListMode *recommendAgentListMode;
@property (nonatomic, strong) XNFMProductCategoryListMode * hotRecommendListMode;
@property (nonatomic, strong) XNFMProductCategoryListMode *shortTermSelectProductsListMode; //日进斗金
@property (nonatomic, strong) XNFMProductCategoryListMode *longTermSelectProductsListMode; //年年有余

+ (instancetype)defaultModule;

/**
 * 产品列表筛选
 * param deadlineValue	期限	string	dLa=不限 dLb=1个月内 dLc=1-3个月 dLd=3-6个月 dLe=6-12个月 dLf=12个月以上
 * param flowRate	年化收益率	string	fRa=不限 fRb=8%以下 fRc=8%-12% fRd=12%以上
 * param userType	用户类型	number	0-不限 1-新手用户
 * param order	顺序	number	0-升序 1-降序
 * param orgCode	机构编码	string	非必需 默认查询全部机构
 * param pageIndex	第几页 >=1,默认为1	number
 * param pageSize	页面条数，默认为10	number
 * param sort	排序	number	1-年化收益 2-产品期限
 **/
- (void)fmProductListWithYearFlowRate:(NSString *)flowRate
                             deadLine:(NSString *)deadlineValue
                             userType:(NSString *)userType
                                 sort:(NSString *)sort
                                order:(NSString *)order
                            pageIndex:(NSString *)pageIndex
                             pageSize:(NSString *)pageSize;

/**
 * 获取搜索条件对应产品的数量
 * 
 * params deadlineValue 
 * params flowRate
 * params ifRookie
 **/
- (void)fmProductSelectedCountWithYearFlowRate:(NSString *)flowRate
                                      deadLine:(NSString *)deadlineValue
                                      ifRookie:(NSString *)ifRookie;

/**
 * 推荐理财师
 * params productId 产品id
 **/
- (void)fmSetRecommendProductWithProductId:(NSString *)productId;

/**
 * 取消推荐
 * params productId 产品id
 **/
- (void)fmCancelRecommendProductWithProductId:(NSString *)productId;

/**
 * 产品分享
 * params productId 产品id
 **/
- (void)fmGetSharedProductInfoWithProductId:(NSString *)productId;

/**
 * 产品推荐选择列表
 * params productId 产品id
 * params searchValue 查询内容（姓名或手机号）
 **/
- (void)fmRecommendProductWithProductId:(NSString *)productId searchValue:(NSString *)searchValue;

/**
 * 产品选择推荐
 * params productId 产品id
 * params userIdString 用户id
 **/
- (void)fmRecommendWithProductId:(NSString *)productId userIdString:(NSString *)userIdString;

/**
 * 机构推荐选择列表
 * params agentCode 机构编码
 * params searchValue 查询内容（姓名或手机号）
 **/
- (void)fmRecommendAgentWithAgentCode:(NSString *)agentCode searchValue:(NSString *)searchValue;

/**
 * 机构选择推荐
 * params agentCode 机构编码
 * params userIdString 用户id
 **/
- (void)fmRecommendWithAgentCode:(NSString *)agentCode userIdString:(NSString *)userIdString;

/**
 * 热门产品
 * */
- (void)fmRequestHotRecommendProductListTop;

/**
 * 精选产品分类列表
 * params cateId 1-日进斗金 2-年年有余
 * param pageIndex	第几页 >=1,默认为1	number
 * param pageSize	页面条数，默认为10	number
 *
 **/
- (void)fmRequestSelectProductListWithCateId:(NSString *)cateId pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;


@end
