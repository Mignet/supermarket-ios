//
//  XNLeiCaiModule.h
//  FinancialManager
//
//  Created by xnkj on 04/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

#define XN_LIECAI_HOME_ACTIVITY_ITEM_NAME @"activityName"
#define XN_LIECAI_HOME_ACTIVITY_ITEM_LINK @"linkUrl"
#define XN_LIECAI_HOME_ITEM_DATAS @"datas"



@class XNLCBrandPromotionMode,XNLCPersonalCardMode,XNLCLevelPrivilegeMode,XNLCSaleGoodNewsListMode,XNLCSaleGoodNewsItemMode, XNGrowthManualListMode, XNGrowthManualCategoryMode, SeekTreasureHotActivityModel, SeekTreasureReadListModel, SeekTreasureRecommendListModel, SeekActivityListModel, XNLCBrandPostersmModel;

@interface XNLeiCaiModule : AppModuleBase

@property (nonatomic, strong) NSArray * bannerListArray;
@property (nonatomic, strong) NSArray * bannerImgUrlListArray;
@property (nonatomic, strong) NSArray * bannerLinkUrlListArray;
@property (nonatomic, strong) XNLCBrandPromotionMode *cfpBrandPromotionMode;
@property (nonatomic, strong) XNLCBrandPromotionMode *customerBrandPromotionMode;
@property (nonatomic, strong) XNLCPersonalCardMode *personalCardMode;
@property (nonatomic, strong) XNLCLevelPrivilegeMode *levelPrivilegeMode;
@property (nonatomic, strong) XNLCSaleGoodNewsListMode *saleGoodNewsListMode;
@property (nonatomic, strong) XNLCSaleGoodNewsItemMode *saleGoodNewsItemMode;
@property (nonatomic, strong) XNGrowthManualListMode *growthManualCategoryMode;
@property (nonatomic, strong) XNGrowthManualListMode *personalCustomListMode;
@property (nonatomic, strong) XNGrowthManualListMode *growthManualCategoryListMode;
@property (nonatomic, assign) BOOL isHaveNewSaleGoodNews; //是否有最新喜报


/***** 4.5.0 (新增) ****/
// 猎才热门活动
@property (nonatomic, strong) SeekTreasureHotActivityModel *SeekTreasureHotActivityModel;

// 猎才最近热读
@property (nonatomic, strong) SeekTreasureReadListModel *seekTreasureReadListModel;

// 猎才热门推荐
@property (nonatomic, strong) SeekTreasureRecommendListModel *seekTreasureRecommendListModel;

//活动专区（活动列表）
@property (nonatomic, strong) SeekActivityListModel *seekActivityListModel;

// 指定类型的推广海报
@property (nonatomic, strong) XNLCBrandPostersmModel *brandPostersmModel;

+ (instancetype)defaultModule;

/**
 * 获首页banner
 **/
- (void)requestHomePageBannerList;

/**
 * 个人品牌推广
 * params type  1邀请理财师 2邀请客户
 **/
- (void)requestBrandPromotion:(NSString *)type;

/**
 * 个人名片
 * params type  1邀请理财师 2邀请客户
 **/
- (void)requestPersonalCard:(NSString *)type;

/**
 * 职级特权
 * userId 用户id
 **/
- (void)requestLevelPrivilegeWithUserId:(NSString *)userId;

/**
 * 出单喜报
 **/
- (void)requestSaleGoodNewsDetailWithId:(NSString *)billId;

/**
 * 往期喜报
 **/
- (void)requestSaleGoodNewsListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize sort:(NSString *)sort;

/**
 * 成长手册分类
 **/
- (void)requestGrowthManualCategory;

/**
 * 个人定制列表
 **/
- (void)requestPersonalCustomList;

/**
 * 分类列表
 * params typeCode 类型编号
 **/
- (void)requestGrowthManualCategoryListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize typeCode:(NSString *)typeCode;

/**
 * 未读喜报
 **/
- (void)requestUnReadSaleGoodNews;


/////////////////////
#pragma mark - 4.5.0 (新增借口) （1、热门活动 2、精选推荐 3、最近热读）
////////////////////////////

/***
 * 猎才-热门活动
 **/
- (void)requestSeekTreasureHotActivity;

/***
 * 猎才-精选推荐
 **/
- (void)requestSeekTreasureRecommend;


/***
 * 猎才-最近热读书
 **/
- (void)requestSeekTreasureRead;

/***
 * 猎才 - 活动专区（活动列表） 
 * appType 活动类别:1理财师，2投资者
 **/
- (void)requestSeekTreasureActivityListPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize AppType:(NSString *)appType;

/***
 * 推广海报 /user/brandPosters (4.5.3)
 */

- (void)request_Liecai_User_BrandPosters;

/***
 * 推广海报类型 /user/postersType (4.5.3)
 */
- (void)request_Liecai_User_PostersType:(NSString *)type;



@end
