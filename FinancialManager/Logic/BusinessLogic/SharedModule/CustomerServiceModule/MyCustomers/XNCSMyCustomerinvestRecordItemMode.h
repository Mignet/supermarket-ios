//
//  MIInvestRecordItemMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 6/26/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MYINFO_INVEST_RECORD_ITEM_FEEAMOUNT  @"feeAmount"
#define XN_MYINFO_INVEST_RECORD_ITEM_HEADIAMGE  @"headImage"
#define XN_MYINFO_INVEST_RECORD_ITEM_INVESTAMT @"investAmt"
#define XN_MYINFO_INVEST_RECORD_ITEM_PLATFORMNAME  @"orgName"
#define XN_MYINFO_INVEST_RECORD_ITEM_INVESTTIME  @"investTime"
#define XN_MYINFO_INVEST_RECORD_ITEM_USERNAME  @"userName"
#define XN_MYINFO_INVEST_RECORD_ITEM_USERTYPE  @"userType"
#define XN_MYINFO_INVEST_RECORD_ITEM_INVESTID @"investId"

@interface XNCSMyCustomerInvestRecordItemMode : NSObject

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

@property (nonatomic, copy) NSString *investId;

/***
 * 投资时间
 **/
@property (nonatomic, copy) NSString *startTime;

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
