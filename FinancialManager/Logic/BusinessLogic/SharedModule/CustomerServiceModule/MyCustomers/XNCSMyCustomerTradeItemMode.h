//
//  XNCSMyCustomerTradeItemMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/21.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*        “time”:”2015-01-01 12:20”;//发生时间
 “tradeType”:”1”,//交易类别(2-申购，3-赎回)
 “amt”:”88888.88”,//金额(申购、赎回)
 “productName”:”天添牛A90天”,// 产品名称
 “yearRate”:”8.5%”,//年化
 “feeRate”:”1.5%”,//佣金
 “startDate”:”2015-09-01”,//起息日期
 “endDate”:” 2015-09-01”,//到期日期(没有值，该行不显示)
 “profit”:120.25,//客户预收益(没有值，该行不显示)
 “feeProfit”:20.23,//佣金(没有值，该行不显示)
*/

#define XN_CS_MYCUSTOMER_TRADE_ITEM_TIME @"time"
#define XN_CS_MYCUSTOMER_TRADE_ITEM_TRADETYPE @"type"
#define XN_CS_MYCUSTOMER_TRADE_ITEM_AMOUNT @"amt"
#define XN_CS_MYCUSTOMER_TRADE_ITEM_PRODUCTNAME @"productName"
#define XN_CS_MYCUSTOMER_TRADE_ITEM_YEARRATE @"rate"
#define XN_CS_MYCUSTOMER_TRADE_ITEM_FEERATE @"feeRate"
#define XN_CS_MYCUSTOMER_TRADE_ITEM_STARTDATE @"startDate"
#define XN_CS_MYCUSTOMER_TRADE_ITEM_ENDDATE @"endDate"
#define XN_CS_MYCUSTOMER_TRADE_ITEM_PROFIT @"profit"
#define XN_CS_MYCUSTOMER_TRADE_ITEM_FEEPROFIT @"feeAmt"

@interface XNCSMyCustomerTradeItemMode : NSObject

@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * tradeType;
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * productName;
@property (nonatomic, strong) NSString * yearRate;
@property (nonatomic, strong) NSString * feeRate;
@property (nonatomic, strong) NSString * startDate;
@property (nonatomic, strong) NSString * endDate;
@property (nonatomic, strong) NSString * profit;
@property (nonatomic, strong) NSString * feeProfit;

+ (instancetype )initMyCustomerTradeItemWithObject:(NSDictionary *)params;
@end
