//
//  XNMyBundRecordingItemMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/22/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MYBUND_RECORDING_ITEM_MODE_ACCOUNT_NUMBER @"accountNumber"
#define XN_MYBUND_RECORDING_ITEM_MODE_FUND_CODE @"fundCode"
#define XN_MYBUND_RECORDING_ITEM_MODE_FUND_NAME @"fundName"
#define XN_MYBUND_RECORDING_ITEM_MODE_MERCHANT_NUMBER @"merchantNumber"
#define XN_MYBUND_RECORDING_ITEM_MODE_ORDER_DATE @"orderDate"
#define XN_MYBUND_RECORDING_ITEM_MODE_PORTFOLIOID @"portfolioId"
#define XN_MYBUND_RECORDING_ITEM_MODE_RSPID @"rspId"
#define XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_AMOUNT @"transactionAmount"
#define XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_CHARGE @"transactionCharge"
#define XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_DATE @"transactionDate"
#define XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_RATE @"transactionRate"
#define XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_STATUS @"transactionStatus"
#define XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_STATUS_MSG @"transactionStatusMsg"
#define XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_TYPE @"transactionType"
#define XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_TYPE_MSG @"transactionTypeMsg"
#define XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_UNIT @"transactionUnit"

@interface XNMyBundRecordingItemMode : NSObject

@property (nonatomic, strong) NSString *accountNumber; //账户号码
@property (nonatomic, strong) NSString *fundCode; //基金代码
@property (nonatomic, strong) NSString *fundName; //基金名称
@property (nonatomic, strong) NSString *merchantdouble; //商户订单流水号
@property (nonatomic, strong) NSString *orderDate; //下单日期
@property (nonatomic, strong) NSString *portfolioId; //组合编码
@property (nonatomic, strong) NSString *rspId; //如果订单为定投计划生成的订单，则返回关联的定投计划；其他则为空值
@property (nonatomic, strong) NSString *transactionAmount; //申购、认购、定投的订单的总购买金额（包含购买费用）
@property (nonatomic, strong) NSString *transactionCharge; //未打折的交易费用
@property (nonatomic, strong) NSString *transactionDate; //交易日期
@property (nonatomic, strong) NSString *transactionRate; //未打折的交易费率
@property (nonatomic, strong) NSString *transactionStatus; //交易状态
@property (nonatomic, strong) NSString *transactionStatusMsg; //交易状态信息
@property (nonatomic, strong) NSString *transactionType; //交易类型
@property (nonatomic, strong) NSString *transactionTypeMsg; //交易类型信息
@property (nonatomic, strong) NSString *transactionUnit; //交易份额

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
