//
//  MIAccountBalanceCommonMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 11/24/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_ACCOUNT_BALANCE_COMMON_MODE_PAGE_COUNT @"pageCount"
#define XN_ACCOUNT_BALANCE_COMMON_MODE_PAGE_INDEX @"pageIndex"
#define XN_ACCOUNT_BALANCE_COMMON_MODE_PAGE_SIZE @"pageSize"
#define XN_ACCOUNT_BALANCE_COMMON_MODE_TOTAL_COUNT @"totalCount"
#define XN_ACCOUNT_BALANCE_COMMON_MODE_DATAS @"datas"

@interface MIAccountBalanceCommonMode : NSObject

@property (nonatomic, assign) NSInteger pageCount; //总页数
@property (nonatomic, assign) NSInteger pageIndex; //当前第几页
@property (nonatomic, assign) NSInteger pageSize; //每页显示的记录数
@property (nonatomic, assign) NSInteger totalCount; //总记录数
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, copy) NSString *type; //类型（1待发放，2已发放）／收支类型(0=全部1=收入|2=支出)

//账户余额月份收益列表
+ (instancetype)initWithAccountBalanceMonthProfixObject:(NSDictionary *)params;

//月度收益明细列表
+ (instancetype)initWithMonthProfixListObject:(NSDictionary *)params;

//资金明细
+ (instancetype)initWithAccountBalanceDetailListObject:(NSDictionary *)params;

@end
