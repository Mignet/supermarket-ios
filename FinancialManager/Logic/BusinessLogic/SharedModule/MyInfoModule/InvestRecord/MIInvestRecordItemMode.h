//
//  MIInvestRecordItemMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 6/26/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MYINFO_INVEST_RECORD_ITEM_FEEAMOUNTSUM  @"feeAmountSum"
#define XN_MYINFO_INVEST_RECORD_ITEM_HEADIAMGE  @"headImage"
#define XN_MYINFO_INVEST_RECORD_ITEM_INVESTAMT @"investAmt"
#define XN_MYINFO_INVEST_RECORD_ITEM_INVESTID @"investId"
#define XN_MYINFO_INVEST_RECORD_ITEM_PLATFORMNAME  @"platformName"
#define XN_MYINFO_INVEST_RECORD_ITEM_STARTTIME  @"startTime"
#define XN_MYINFO_INVEST_RECORD_ITEM_STARTTIMESTR  @"startTimeStr"
#define XN_MYINFO_INVEST_RECORD_ITEM_USERNAME  @"userName"
#define XN_MYINFO_INVEST_RECORD_ITEM_USERTYPE  @"userType"

@interface MIInvestRecordItemMode : NSObject

@property (nonatomic, copy) NSString *canRedemption; //是否可赎回 0-不可赎回 1-可赎回

// 保险审核佣金计算状态
@property (nonatomic, copy) NSString *clearingStatus; // 0-待计算 1-计算成功 2-计算失败

/***
 * 我的佣金
 **/
@property (nonatomic, copy) NSString *feeAmountSum;

/***
 * 理财师头像
 **/
@property (nonatomic, copy) NSString *headImage;

/***
 * 投资金额
 **/
@property (nonatomic, copy) NSString *investAmt;

/***
 * 投资记录id
 **/
@property (nonatomic, copy) NSString *investId;

/***
 * 投资时间
 **/
@property (nonatomic, copy) NSString *startTime;

/***
 * 投资时间 字符串
 **/
@property (nonatomic, copy) NSString *startTimeStr;

/***
 * 机构名称
 **/
@property (nonatomic, copy) NSString *platformName;

/***
 * 理财师名称
 **/
@property (nonatomic, copy) NSString *userName;

/***
 * 用户类型 0- 客户 1-直推 2-二级 3-三级
 **/
@property (nonatomic, copy) NSString *userType;

+ (instancetype )initWithObject:(NSDictionary *)params;

@end
