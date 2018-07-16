//
//  SignCalendarModuleObserver.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/14.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//


@protocol SignCalendarModuleObserver <NSObject>
@optional

// 升级信息
- (void)recommendMemberDidReceive:(SignCalendarModule *)module;
- (void)recommendMemberDidFailed:(SignCalendarModule *)module;

// 签到
- (void)userSignDidReceive:(SignCalendarModule *)module;
- (void)userSignDidFailed:(SignCalendarModule *)module;

// 签到信息
- (void)userSignInfoReceive:(SignCalendarModule *)module;
- (void)userSignInfoDidFailed:(SignCalendarModule *)module;

// 分享
- (void)userSignShareReceive:(SignCalendarModule *)module;
- (void)userSignShareDidFailed:(SignCalendarModule *)module;

// 分享信息
- (void)userSignShareInfoReceive:(SignCalendarModule *)module;
- (void)userSignShareInfoDidFailed:(SignCalendarModule *)module;

// 奖励金转账户
- (void)userSignBounsTransferReceive:(SignCalendarModule *)module;
- (void)userSignBounsTransferDidFailed:(SignCalendarModule *)module;

// 签到日历
- (void)userSignCalendarReceive:(SignCalendarModule *)module;
- (void)userSignCalendarDidFailed:(SignCalendarModule *)module;

// 签到统计
- (void)userSignStatisticsDidFailed:(SignCalendarModule *)module;
- (void)userSignStatisticsReceive:(SignCalendarModule *)module;

// 用户签到记录
- (void)userSignRecordsReceive:(SignCalendarModule *)module;
- (void)userSignRecordsDidFailed:(SignCalendarModule *)module;

// 4.5.1 交易日历统计
- (void)investCalendarStatisticsReceive:(SignCalendarModule *)module;
- (void)investCalendarStatisticsDidFailed:(SignCalendarModule *)module;

// 4.5.1 回款日历统计
- (void)personcenterRepamentCalendarStatisticsReceive:(SignCalendarModule *)module;
- (void)ipersoncenterRepamentCalendarStatisticsDidFailed:(SignCalendarModule *)module;

@end
