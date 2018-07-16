//
//  XNFinancialManagerModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

#define XNFMPRODUCTTYPELISTDATA         @"datas"
#define XNFMBATCHINVITEDTOREVIEWCONTENT @"content"
#define XNSHAREDCONTENT @"shareContent"


@class XNFMProductCategoryListMode,XNFMProductDetailMode,XNFMProfitCaculateMode, XNFMAgentListMode, XNFMAgentSelectConditionMode, XNFMAgentDetailMode, XNFMAgentListItemMode, ProductRedPacketModel;

@interface XNFinancialManagerModule : AppModuleBase

@property (nonatomic, strong) XNFMProductDetailMode    * productDetailMode;
@property (nonatomic, strong) XNFMProductCategoryListMode * productListMode;
@property (nonatomic, strong) NSArray                  * productCategoryStatisticArray;
@property (nonatomic, strong) NSArray                 * productScrollCategoryStaticsticArray;
@property (nonatomic, strong) NSArray                  * profitCaculateModeArray;
@property (nonatomic, strong) NSDictionary                * productSharedMode;
@property (nonatomic, strong) XNFMAgentListMode        * agentListMode;
@property (nonatomic, strong) XNFMAgentSelectConditionMode * agentSelectConditionMode;
@property (nonatomic, strong) XNFMAgentDetailMode * agentDetailMode;
@property (nonatomic, strong) XNFMProductCategoryListMode * agentSaleProductListMode;

@property (nonatomic, strong) NSArray * productTagCategoryStatisticArray;//产品标的
@property (nonatomic, strong) XNFMProductListItemMode * hotProductMode;
@property (nonatomic, strong) NSArray            * choicenessPlatformArray;

/*** 产品可用红包数据模型 **/
@property (nonatomic, strong) ProductRedPacketModel *productRedPacketModel;

+ (instancetype)defaultModule;

/**
 * 产品-详情
 * params productId 产品id
 **/
- (void)fmProductDetailWithProductId:(NSString *)productId;

/**
 * 产品-分类统计
 * params cateIdList 产品分类id列表 非必需 默认根据不同的app类型查询对应的所有分类信息 1-热门产品 2-新手产品 3-短期产品 4-高收益产品 5-稳健收益产品 801-理财师推荐产品 901-首投标 902-复投标 多个一起查询的时候请使用,分开 如：1,2,3,4,5,801,901,902 不传时则查询所有的产品分类
 **/
- (void)fmProductCategoryStatisticWithCateIdList:(NSString *)cateIdList;

/**
 * 产品-产品分类列表
 * params cateId 产品分类id
 * params order 顺序 0-升序 1-降序
 * params orgCode 机构编码 (非必需)
 * params sort 排序类型 1-默认排序 2-年化收益 3-产品期限
 * params pageIndex
 * params pageSize
 **/
- (void)fmProductCategoryListWithCateId:(NSString *)strId orgCode:(NSString *)orgCode sort:(NSString *)sort order:(NSString *)order pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;

/**
 * 产品热推
 **/
- (void)fmProductHotRecommend;

/**
 * 理财师佣金计算
 * params params 
 **/
- (void)fmProductDetailCaculateComissionWithParams:(NSDictionary *)params;


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
 * 机构列表
 * params pageIndex 页码
 * params pageSize 每页显示条数
 */
- (void)fmAgentListAtPageIndex:(NSString *)pageIndex
                      pageSize:(NSString *)pageSize;


/**
 * 机构筛选条件
 */
- (void)fmAgentSelectCondition;

/**
 * 平台信息和详情
 * params orgNo 机构编码
 */
- (void)fmAgentDetailWithOrgNo:(NSString *)orgNo;

/**
 * 平台在售产品
 * params orgNo 机构编码
 * params pageIndex 页码
 * params pageSize 每页显示条数
 * params order 顺序
 * params sort 排序
 */
- (void)fmAgentSaleProductListWithOrgNo:(NSString *)orgNo pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize order:(NSString *)order sort:(NSString *)sort;

/**
 * 产品标的
 * params cateIdList 产品分类id列表
 **/
- (void)fmRequestProductTagList;

/**
 * 优选产品
 * params cateIdList
 **/
- (void)fmRequestHotProductWithCateId:(NSString *)cateId;

/**
 * 精选平台
 *
 **/
- (void)fmAgentChoicenessPlatform;

/***
 *  4.5.3 产品可用红包详情
 */
- (void)product_product_RedPacket:(NSString *)productId;




@end
