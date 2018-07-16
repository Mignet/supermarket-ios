//
//  XNCSCustomerDetailMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/20.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_CS_CUSTOMER_DETAIL_USERID @"userId"
#define XN_CS_CUSTOMER_DETAIL_CURRINVESTAMT @"currInvestAmt"
#define XN_CS_CUSTOMER_DETAIL_FIRSTINVESTTIME @"firstInvestTime"
#define XN_CS_CUSTOMER_DETAIL_FOLLOW @"follow"
#define XN_CS_CUSTOMER_DETAIL_HEADIMAGE @"headImage"
#define XN_CS_CUSTOMER_DETAIL_LOGINTIME @"loginTime"
#define XN_CS_CUSTOMER_DETAIL_FIRSTRCPDATE @"firstRcpDate"
#define XN_CS_CUSTOMER_DETAIL_MOBILE @"mobile"
#define XN_CS_CUSTOMER_DETAIL_REGISTTIME @"registTime"
#define XN_CS_CUSTOMER_DETAIL_THIEMONTHINVESTAMT @"thisMonthInvestAmt"
#define XN_CS_CUSTOMER_DETAIL_THISMONTHPROFIT @"thisMonthProfit"
#define XN_CS_CUSTOMER_DETAIL_TOTALINVESTAMT @"totalInvestAmt"
#define XN_CS_CUSTOMER_DETAIL_USERNAME @"userName"
#define XN_CS_CUSTOMER_DETAIL_REGISTEREDORGLIST @"registeredOrgList"
#define XN_CS_CUSTOMER_DETAIL_CAREDSTASTUS @"follow"
#define XN_CS_CUSTOMER_DETAIL_REGISTEREDORGLIST_ORGICO @"orgLogo"
#define XN_CS_CUSTOMER_DETAIL_TOTALPROFIT @"totalProfit"

@interface XNCSCustomerDetailMode : NSObject

@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * currInvestAmt;
@property (nonatomic, strong) NSString * firstInvestTime;
@property (nonatomic, assign) BOOL       follow;//是否关注
@property (nonatomic, strong) NSString * headImage;
@property (nonatomic, strong) NSString * loginTime;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * registTime;
@property (nonatomic, strong) NSString * thisMonthInvestAmt;
@property (nonatomic, strong) NSString * thisMonthProfit;
@property (nonatomic, strong) NSString * totalProfit;
@property (nonatomic, strong) NSString * totalInvestAmt;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, assign) BOOL       caredStatus;
@property (nonatomic, strong) NSArray  * registeredOrgList;

+ (instancetype )initCustomerDetailWithObject:(NSDictionary *)params;
@end
