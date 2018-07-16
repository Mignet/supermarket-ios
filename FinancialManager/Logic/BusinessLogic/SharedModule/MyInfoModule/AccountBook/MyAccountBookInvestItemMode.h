//
//  MyAccountBookinvestitemMode.h
//  FinancialManager
//
//  Created by xnkj on 19/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_ACCOUNTBOOK_INVEST_ITEM_INVESTID @"id"
#define XN_ACCOUNTBOOK_INVEST_ITEM_INVESTAMT @"investAmt"
#define XN_ACCOUNTBOOK_INVEST_ITEM_INVESTDIRECTION @"investDirection"
#define XN_ACCOUNTBOOK_INVEST_ITEM_PROFIT @"profit"
#define XN_ACCOUNTBOOK_INVEST_ITEM_REMARK @"remark"
#define XN_ACCOUNTBOOK_INVEST_ITEM_STATUS @"status"
#define XN_ACCOUNTBOOK_INVEST_ITEM_CREATETIME @"createTime"

@interface MyAccountBookInvestItemMode : NSObject

@property (nonatomic, strong) NSString * investId;
@property (nonatomic, strong) NSString * investAmt;
@property (nonatomic, strong) NSString * investProfit;
@property (nonatomic, strong) NSString * direction;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, assign) BOOL  status;//true表示再投
@property (nonatomic, strong) NSString * createTime;

+ (instancetype)initAccountBookInvestItemWithParams:(NSDictionary *)params;
@end
