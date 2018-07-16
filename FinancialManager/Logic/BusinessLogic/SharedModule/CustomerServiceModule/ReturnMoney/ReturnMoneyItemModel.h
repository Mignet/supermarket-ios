//
//  ReturnMoneyItemModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/19.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_CS_RETURN_MONEY_ENDTIME           @"endTime"
#define XN_CS_RETURN_MONEY_ENDTIMESTR        @"endTimeStr"
#define XN_CS_RETURN_MONEY_HEADIMAGE         @"headImage"
#define XN_CS_RETURN_MONEY_INVESTAMT         @"investAmt"
#define XN_CS_RETURN_MONEY_INVESTID          @"investId"
#define XN_CS_RETURN_MONEY_ORDERTYPE         @"orderType"
#define XN_CS_RETURN_MONEY_PLATFORMNAME      @"platformName"
#define XN_CS_RETURN_MONEY_PROFIT            @"profit"
#define XN_CS_RETURN_MONEY_REPAYMENTUSERTYPE @"repaymentUserType"
#define XN_CS_RETURN_MONEY_USERNAME          @"userName"


@interface ReturnMoneyItemModel : NSObject


/***
 * 回款时间
 **/
@property (nonatomic, copy) NSString *endTime;

/***
 * 回款时间字符串
 **/
@property (nonatomic, copy) NSString *endTimeStr;

/***
 * 头像
 **/
@property (nonatomic, copy) NSString *headImage;

/***
 * 回款本金
 **/
@property (nonatomic, copy) NSString *investAmt;

/***
 * 投资记录id
 **/
@property (nonatomic, copy) NSString *investId;

/***
 * 排序
 **/
@property (nonatomic, copy) NSString *orderType;

/***
 * 平台名称
 **/
@property (nonatomic, copy) NSString *platformName;

/***
 * 预期收益
 **/
@property (nonatomic, copy) NSString *profit;

/***
 * 回款客户类型  0- 客户 1-直推
 **/
@property (nonatomic, copy) NSString *repaymentUserType;

/***
 * 用户名称
 **/
@property (nonatomic, copy) NSString *userName;


+ (instancetype )initeturnMoneyItemWithObject:(NSDictionary *)params;

@end
