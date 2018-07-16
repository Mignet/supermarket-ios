//
//  XNHomeModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

#define XNFMPRODUCTTYPELISTDATA         @"datas"

@class XNHomeCommissionMode, XNCfgMsgListMode, XNFMProductCategoryListMode,XNClassRoomListMode, XNHomeAchievementModel;
@interface XNHomeModule : AppModuleBase

@property (nonatomic, strong) NSArray * bannerListArray;
@property (nonatomic, strong) NSArray * bannerImgUrlListArray;
@property (nonatomic, strong) NSArray * bannerLinkUrlListArray;
@property (nonatomic, strong) XNHomeCommissionMode *homeCommissionMode;
@property (nonatomic, strong) XNCfgMsgListMode *homeHotCfgMsgListMode;
@property (nonatomic, strong) XNFMProductCategoryListMode *homeHotProductsListMode;
@property (nonatomic, strong) XNClassRoomListMode * classRoomListMode;

@property (nonatomic, strong) XNHomeAchievementModel *achievementModel;

+ (instancetype)defaultModule;

/**
 * 首页-获取banner列表
 * */
- (void)requestHomePageBannerList;

//banner转化
- (void)convertHomePageListMode:(NSDictionary *)dic;

/**
 * 获取佣金，出单
 **/
- (void)requestHomePageCommission;

/**
 * 热门资讯
 **/
- (void)requestHomePageHotCfgMsgList;

/**
 * 首页精选产品
 **/
- (void)requestHomePageHotProductsList;

/*
 * 猎财课堂
 **/
- (void)requestLcClassRoomList;

/***
 * 获取猎才大师平台业绩 /api/homepage/lcs/achievement/4.3.0
 **/
- (void)requestLcsAchievement;

@end
