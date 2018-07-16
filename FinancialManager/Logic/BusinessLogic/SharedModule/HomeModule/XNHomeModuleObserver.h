//
//  XNHomeModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

@protocol XNHomeModuleObserver <NSObject>
@optional

//获取首页banner列表
- (void)XNHomeModuleBannerListDidReceive:(XNHomeModule *)module;
- (void)XNHomeModuleBannerListDidFailed:(XNHomeModule *)module;

//佣金，出单
- (void)XNHomeModuleCommissionDidReceive:(XNHomeModule *)module;
- (void)XNHomeModuleCommissionDidFailed:(XNHomeModule *)module;

//热门资讯
- (void)XNHomeModuleCfgMsgListDidReceive:(XNHomeModule *)module;
- (void)XNHomeModuleCfgMsgListDidFailed:(XNHomeModule *)module;

//首页精选产品
- (void)XNHomeModuleHotProductsListDidReceive:(XNHomeModule *)module;
- (void)XNHomeModuleHotProductsListDidFailed:(XNHomeModule *)module;

//猎财课堂列表
- (void)XNHomeModuleLCClassRoomListDidReceive:(XNHomeModule *)module;
- (void)XNHomeModuleLCClassRoomListDidFailed:(XNHomeModule *)module;

//首页了解我们猎财大师平台业绩
- (void)RequestLcsAchievementDidReceive:(XNHomeModule *)module;
- (void)RequestLcsAchievementDidFailed:(XNHomeModule *)module;


@end
