//
//  XNMIHomePageInfoMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/* “userName”:”张三”,//用户名称
 “mobile”:”15062375160”,//手机号码
 “authentication”:true,//是否实名验证(true是，false否)
 “cfgLevelName”:”中级理财师”,//理财师等级
 "monthProfit":"5425.82",//本月收益(元)
 “partnerCount”:”11”,//团队人数
 “msgCount”:”11”//消息
 “feeProfit”:”800.00”//本月销售佣金
 “recommendProfit”:”88.18”//本月推荐收益
 “accountBalance”:”12828.50”//账户余额
 “withdrawAmount”:”1200.00”//提现中金额
 “invitationDesc”:”佣金赚不停”//邀请客户描述
 “cfpDesc”:”享推荐收益”//推荐理财师描述
 “newPartnerCount”:”2” //新增理财师数量
 “image":'xxx" //用户头像
 "levelExperience" //用户及积分
*/
#define XN_MYINFO_HOMEPAGE_USER_HEADERIMAGE @"headImage"
#define XN_MYINFO_HOMEPAGE_MOBILE @"mobile"
#define XN_MYINFO_HOMEPAGE_AUTHENTICATION @"isBindBankCard"
#define XN_MYINFO_HOMEPAGE_CFGLEVELNAME @"grade"


#define XN_MYINFO_HOMEPAGE_PACKETMONEY @"totalAmount"
#define XN_MYINFO_HOMEPAGE_MONTH_PROFIT @"monthIncome"
#define XN_MYINFO_HOMEPAGE_TOTAL_INCOME @"totalIncome"

#define XN_MYINFO_HOMEPAGE_BOOK @"accountBook"
#define XN_MYINFO_HOMEPAGE_COUPON @"coupon"
#define XN_MYINFO_HOMEPAGE_CUSTOMERMEMBER @"customerMember"
#define XN_MYINFO_HOMEPAGE_GRADEPRIVI @"gradePrivi"
#define XN_MYINFO_HOMEPAGE_INSURANCE @"insurance"
#define XN_MYINFO_HOMEPAGE_P2P @"netLoan"
#define XN_MYINFO_HOMEPAGE_PAYMENTDATE @"paymentDate"
#define XN_MYINFO_HOMEPAGE_TRANRECORDDATE @"tranRecordDate"
#define XN_MYINFO_HOMEPAGE_TEAMMEMBER @"teamMember"
#define XN_MYINFO_HOMEPAGE_NEW_TRANRECORDSTATUS @"newTranRecordStatus"
#define XN_MYINFO_HOMEPAGE_NEW_PAYMENTRECORDSTATUS @"newPaymentRecordStatus"
#define XN_MYINFO_HOMEPAGE_MSGCOUNT @"msgCount"

@interface XNMIHomePageInfoMode : NSObject

@property (nonatomic, strong) NSString * headImage;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, assign) BOOL       authentication;
@property (nonatomic, strong) NSString * cfgLevelName;

@property (nonatomic, strong) NSString * packetMoneyIncome;
@property (nonatomic, strong) NSString * monthIncome;
@property (nonatomic, strong) NSString * totalIncome;

@property (nonatomic, strong) NSString * accountBook;
@property (nonatomic, strong) NSString * coupon;//优惠券
@property (nonatomic, strong) NSString * customerMember;
@property (nonatomic, strong) NSString * gradePrivi;
@property (nonatomic, strong) NSString * insurance;
@property (nonatomic, strong) NSString * p2p;
@property (nonatomic, strong) NSString * paymentDate;
@property (nonatomic, strong) NSString * tranRecordDate;
@property (nonatomic, strong) NSString * teamMember;
@property (nonatomic, copy)   NSString * grade;
@property (nonatomic, assign) BOOL newTranRecordStatus;//是否有新的交易记录
@property (nonatomic, assign) BOOL newPaymentRecordStatus;//是否有新的回款记录

@property (nonatomic, strong) NSString * msgCount;



+ (instancetype )initHomePageWithObject:(NSDictionary *)params;
@end
