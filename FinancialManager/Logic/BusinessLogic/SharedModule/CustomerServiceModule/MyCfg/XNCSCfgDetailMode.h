//
//  XNCSCustomerDetailMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/20.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_CS_CUSTOMER_DETAIL_CURRINVESTAMT @"currInvestAmt"
#define XN_CS_CFG_DIRECT_RECOM_CFP @"directRecomCfp"
#define XN_CS_CUSTOMER_DETAIL_FIRSTINVESTTIME @"firstInvestTime"
#define XN_CS_CUSTOMER_DETAIL_FOLLOW @"follow"
#define XN_CS_CFG_DETAIL_GRADE @"grade"
#define XN_CS_CUSTOMER_DETAIL_HEADIMAGE @"headImage"
#define XN_CS_CUSTOMER_DETAIL_LOGINTIME @"loginTime"
#define XN_CS_CUSTOMER_DETAIL_MOBILE @"mobile"
#define XN_CS_CUSTOMER_DETAIL_REGISTTIME @"registTime"
#define XN_CS_CUSTOMER_DETAIL_REGISTEREDORGLIST @"registeredOrgList"
#define XN_CS_CUSTOMER_DETAIL_REGISTEREDORGLIST_ORGICO @"orgLogo"
#define XN_CS_CFG_SECONDLEVEL_CFG @"secondLevelCfp"
#define XN_CS_CUSTOMER_DETAIL_THIEMONTHINVESTAMT @"thisMonthIssueAmt"
#define XN_CS_CUSTOMER_DETAIL_THISMONTHPROFIT @"thisMonthProfit"
#define XN_CS_CUSTOMER_DETAIL_TOTALINVESTAMT @"totalIssueAmt"
#define XN_CS_CFG_DETAIL_TOTAL_PROFIT @"totalProfit"
#define XN_CS_CUSTOMER_DETAIL_USERNAME @"userName"

@interface XNCSCfgDetailMode : NSObject

@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * currInvestAmt;
@property (nonatomic, strong) NSString * directRecomCfp;
@property (nonatomic, strong) NSString * firstInvestTime;
@property (nonatomic, assign) BOOL       follow;//是否关注
@property (nonatomic, strong) NSString * grade;
@property (nonatomic, strong) NSString * headImage;
@property (nonatomic, strong) NSString * loginTime;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * registTime;
@property (nonatomic, strong) NSArray  * registeredOrgList;
@property (nonatomic, strong) NSString * secondLevelCfp;

@property (nonatomic, strong) NSString * thisMonthIssueAmt;
@property (nonatomic, strong) NSString * thisMonthProfit;
@property (nonatomic, strong) NSString * totalIssueAmt;
@property (nonatomic, strong) NSString * totalProfit;
@property (nonatomic, strong) NSString * userName;


+ (instancetype )initCfgDetailWithObject:(NSDictionary *)params;
@end
