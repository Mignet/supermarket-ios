//
//  RankListModuleObserver.h
//  FinancialManager
//
//  Created by xnkj on 22/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

@class RankListModule;
@protocol RankListModuleObserver <NSObject>
@optional

//获取我的排行
- (void)xnRankListModuleGetMyProfitRankDidSuccess:(RankListModule *)module;
- (void)xnRankListModuleGetMyProfitRankDidFailed:(RankListModule *)module;

//获取排行列表
- (void)xnRankListModuleGetProfitListRankDidSuccess:(RankListModule *)module;
- (void)xnRankListModuleGetProfitListRankDidFailed:(RankListModule *)module;

//获取我leader的排行
- (void)xnRankListModuleGetMyLeaderProfitRankDidSuccess:(RankListModule *)module;
- (void)xnRankListModuleGetMyLeaderProfitRankDidFailed:(RankListModule *)module;

//获取leader排行列表
- (void)xnRankListModuleGetLeaderProfitListRankDidSuccess:(RankListModule *)module;
- (void)xnRankListModuleGetLeaderProfitListRankDidFailed:(RankListModule *)module;

//获取leader排行列表
- (void)xnRankListModuleGetLeaderProfitStatusDidSuccess:(RankListModule *)module;
- (void)xnRankListModuleGetLeaderProfitStatusDidFailed:(RankListModule *)module;

//获取职级计算所需的基本数据
- (void)xnRankListModuleGetRankCalcBaseDataListDidSuccess:(RankListModule *)module;
- (void)xnRankListModuleGetRankCalcBaseDataListDidFailed:(RankListModule *)module;

@end
