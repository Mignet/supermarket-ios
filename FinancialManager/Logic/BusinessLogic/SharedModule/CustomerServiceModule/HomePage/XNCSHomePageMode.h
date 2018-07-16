//
//  XNCSHomePageMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/20.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_CS_HOMEPAGE_DAYINVESTAMT @"dayInvestAmt"
#define XN_CS_HOMEPAGE_HASCUSTOMER @"hasCustomer"
#define XN_CS_HOMEPAGE_HASTEAMMEMBERS @"hasTeamMembers"
#define XN_CS_HOMEPAGE_LEVEL @"level"
#define XN_CS_HOMEPAGE_MINTIME @"minTime"
#define XN_CS_HOMEPAGE_MONTHINVESTAMT @"monthInvestAmt"
#define XN_CS_HOMEPAGE_NEWBACKTRADECOUNT @"newBacktradeCount"
#define XN_CS_HOMEPAGE_NEWBUYTRADECOUNT @"newBuytradeCount"
#define XN_CS_HOMEPAGE_NEWCUSTOMERCOUNT @"newCustomerCount"
#define XN_CS_HOMEPAGE_NEWMESSAGECOUNT @"newMsgCount"
#define XN_CS_HOMEPAGE_TEAMCOUNT @"teamCount"
#define XN_CS_HOMEPAGE_THIEMONTHALLOWANCE @"thisMonthAllowance"
#define XN_CS_HOMEPAGE_THISMONTHFEE @"thisMonthFee"
#define XN_CS_HOMEPAGE_THISMONTHTEAMSALEAMOUNT @"thisMonthTeamSaleAmount"
#define XN_CS_HOMEPAGE_TOTALINVESTAMT @"totalInvestAmt"
#define XN_CS_HOMEPAGE_LEADERPROFIT @"leaderProfit"
#define XN_CS_HOMEPAGE_FEEMONTH @"feeMonth"

@interface XNCSHomePageMode : NSObject

@property (nonatomic, strong) NSString * dayInvestAmt;
@property (nonatomic, strong) NSString * hasCustomer;
@property (nonatomic, strong) NSString * hasTeamMembers;
@property (nonatomic, strong) NSString * level;
@property (nonatomic, strong) NSString * minTime;
@property (nonatomic, strong) NSString * monthInvestAmt;
@property (nonatomic, strong) NSString * backtradeCount;
@property (nonatomic, strong) NSString * buytradeCount;
@property (nonatomic, strong) NSString * tradeCount;
@property (nonatomic, strong) NSString *  customerCount;

@property (nonatomic, strong) NSString *  msgCount;
@property (nonatomic, strong) NSString *  teamCount;
@property (nonatomic, strong) NSString *  thisMonthAllowance;
@property (nonatomic, strong) NSString *  thisMonthFee;
@property (nonatomic, strong) NSString *  thisMonthTeamSaleAmount;
@property (nonatomic, strong) NSString *  totalInvestAmt;

@property (nonatomic, strong) NSString * leaderProfit;
@property (nonatomic, strong) NSString * feeMonth; //排行榜月份

+ (instancetype )initCSHomePageWithObject:(NSDictionary *)params;
@end
