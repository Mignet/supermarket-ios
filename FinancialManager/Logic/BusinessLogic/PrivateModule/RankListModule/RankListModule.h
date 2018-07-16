//
//  RankListModule.h
//  FinancialManager
//
//  Created by xnkj on 22/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

#define XN_HOME_RANK_LEADER_STATUS_CFPSTATUS @"cfpStatus"

@class MyRankMode, RankListMode, RankCalcBaseDataListMode;
@interface RankListModule : AppModuleBase

@property (nonatomic, strong) MyRankMode * myProfitRankMode;
@property (nonatomic, strong) RankListMode * rankListMode;

@property (nonatomic, strong) MyRankMode * myLeaderRankMode;
@property (nonatomic, strong) RankListMode * myLeaderListMode;
@property (nonatomic, strong) RankCalcBaseDataListMode *rankCalcBaseDataListMode;

@property (nonatomic, strong) NSString * cfpLeaderStatus; //0=满足条件 1=满足条件，下级有独立计算 2=不满足

//获取我的排名
- (void)requestMyProfitRank;

//获取排行列表
- (void)requestProfitRankListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;

//获取我的leader奖励
- (void)requestMyLeaderProfitRank;

//获取leader奖励排行
- (void)requestLeaderProfitRankListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;

//获取理财师leader满足的状态
- (void)requestLeaderProfitStatus;

//获取职级计算所需的基本数据
- (void)requestRankCalcBaseDataList;

@end
