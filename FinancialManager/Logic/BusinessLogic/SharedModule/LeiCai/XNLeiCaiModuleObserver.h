//
//  XNLeiCaiModuleObserver.h
//  FinancialManager
//
//  Created by xnkj on 04/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XNLeiCaiModule;
@protocol XNLeiCaiModuleObserver <NSObject>
@optional

//理财资讯
- (void)XNMyInfoModuleCfgMsgDidReceive:(XNLeiCaiModule *)module;
- (void)XNMyInfoModuleCfgMsgDidFailed:(XNLeiCaiModule *)module;

//未读活动
- (void)XNLeiCaiModuleGetUnReadInformationDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModuleGetUnReadInformationDidFailed:(XNLeiCaiModule *)module;

//活动列表
- (void)XNLeiCaiModuleGetActivityDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModuleGetActivityDidFailed:(XNLeiCaiModule *)module;

//机构活动列表
- (void)XNLeiCaiModuleGetAgentActivityDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModuleGetAgentActivityDidFailed:(XNLeiCaiModule *)module;

//课程列表
- (void)XNLeiCaiModuleGetSchoolListDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModuleGetSchoolListDidFailed:(XNLeiCaiModule *)module;

//获取首页banner列表
- (void)XNHomeModuleLcBannerListDidReceive:(XNLeiCaiModule *)module;
- (void)XNHomeModuleLcBannerListDidFailed:(XNLeiCaiModule *)module;

//获取首页相关数据
- (void)XNHomeModuleLcDataDidReceive:(XNLeiCaiModule *)module;
- (void)xnhomemodulelcDataDidFailed:(XNLeiCaiModule *)module;

//获取首页相关数据
- (void)XNHomeModuleLcActivityDidReceive:(XNLeiCaiModule *)module;
- (void)XNHomeModuleLcActivityDidFailed:(XNLeiCaiModule *)module;

//个人品牌推广
- (void)XNLeiCaiModuleBrandPromotionDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModuleBrandPromotionDidFailed:(XNLeiCaiModule *)module;

//个人名片
- (void)XNLeiCaiModulePersonalCardDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModulePersonalCardDidFailed:(XNLeiCaiModule *)module;

// 职级特权
- (void)XNLeiCaiModuleLevelPrivilegeDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModuleLevelPrivilegeDidFailed:(XNLeiCaiModule *)module;

// 职级特权
- (void)XNLeiCaiModuleLevelDirectPrivilegeDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModuleLevelDirectPrivilegeDidFailed:(XNLeiCaiModule *)module;

//出单喜报
- (void)XNLeiCaiModuleSaleGoodNewsDetailDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModuleSaleGoodNewsDetailDidFailed:(XNLeiCaiModule *)module;

//往期喜报
- (void)XNLeiCaiModuleSaleGoodNewsListDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModuleSaleGoodNewsListDidFailed:(XNLeiCaiModule *)module;

//成长手册分类
- (void)XNLeiCaiModuleGrowthManualCategoryDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModuleGrowthManualCategoryDidFailed:(XNLeiCaiModule *)module;

//个人定制列表
- (void)XNLeiCaiModulePersonalCustomListDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModulePersonalCustomListDidFailed:(XNLeiCaiModule *)module;

//分类列表
- (void)XNLeiCaiModuleGrowthManualCategoryListDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModuleGrowthManualCategoryListDidFailed:(XNLeiCaiModule *)module;

//未读喜报
- (void)XNLeiCaiModuleUnReadSaleGoodNewsDidSuccess:(XNLeiCaiModule *)module;
- (void)XNLeiCaiModuleUnReadSaleGoodNewsDidFailed:(XNLeiCaiModule *)module;



/***** 4.5.0 新增 （获取猎才热门活动） ***/
- (void)SeekRequestSeekTreasureHotActivityDidSuccess:(XNLeiCaiModule *)module;
- (void)SeekRequestSeekTreasureHotActivityDidFailed:(XNLeiCaiModule *)module;

/***** 4.5.0 新增 （获取猎才热门推荐） ***/
- (void)SeekTreasureRecommendListDidSuccess:(XNLeiCaiModule *)module;
- (void)SeekTreasureRecommendListDidFailed:(XNLeiCaiModule *)module;

/***** 4.5.0 新增 （获取猎才最近热读） ***/
- (void)SeekTreasureReadListDidSuccess:(XNLeiCaiModule *)module;
- (void)SeekTreasureReadListDidFailed:(XNLeiCaiModule *)module;

/**** 4.5.0 获取猎才活动专区（）活动列表 ***/
- (void)SeekActivityListModelDidSuccess:(XNLeiCaiModule *)module;
- (void)SeekActivityListModelDidFailed:(XNLeiCaiModule *)module;

/****4.5.3 猎财推广海报类型 ***/
- (void)insurance_Liecai_User_PostersTypeDidReceive:(XNLeiCaiModule *)module;
- (void)insurance_Liecai_User_PostersTypeDidFailed:(XNLeiCaiModule *)module;

/**** 4.5.3指定类型的推广海报 ***/
- (void)insurance_Liecai_User_BrandPostersDidReceive:(XNLeiCaiModule *)module;
- (void)insurance_Liecai_User_BrandPostersDidFailed:(XNLeiCaiModule *)module;



@end
