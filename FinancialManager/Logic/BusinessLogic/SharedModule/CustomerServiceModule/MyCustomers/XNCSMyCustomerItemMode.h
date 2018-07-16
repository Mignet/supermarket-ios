//
//  XNCSMyCustomerItemMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/20.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

//“customerId”:”555252312sdf”//客户id
//“customerName”:”张三”,//客户名称
//“customerMobile”:”1506049528”,//客户手机号码
//“nearInvestAmt”:”50000.06”, //最近投资
//“registerTime”:”2015-09-30”, //注册时间
//“nearEndDate”:”2015-09-30”, //到期日期
//“currInvestAmt”:”1233.32”, //累计投资
//“totalInvestCount”:”12”, //投资笔数
//“important”:true,//是否重要客户(true是,false否)
//“readFlag”:true,//是否已读(true已读，false未读)
//“sysImpFlag”:true//是否平台导入(true是,false否)
//"easemobAcct":"3e5e57fc05d0581d4b2efdd0266623b",//环信帐号
//"easemobPassword":"Rt3K4sPtbihxDI6mHDRwhroMuIU=",//环信密码

#define XN_CS_MYCUSTOMER_ITEM_CUSTOMERID @"userId"
#define XN_CS_MYCUSTOMER_ITEM_CUSTEOMERNAME @"userName"
#define XN_CS_MYCUSTOMER_ITEM_CUSTEOMERMOBILE @"mobile"
#define XN_CS_MYCUSTOMER_ITEM_NEARINVESTAMT @"nearInvestAmt"
#define XN_CS_MYCUSTOMER_ITEM_REGISTERTIME @"registerTime"
#define XN_CS_MYCUSTOMER_ITEM_NEARINVESTDATE @"nearInvestDate"
#define XN_CS_MYCUSTOMER_ITEM_NEWAENDDATE @"nearEndDate"
#define XN_CS_MYCUSTOMER_ITEM_TOTALINVESTAMOUNT @"totalInvestAmt"
#define XN_CS_MYCUSTOMER_ITEM_TOTALINVESTCOUNT @"totalInvestCount"
#define XN_CS_MYCUSTOMER_ITEM_IMPROTANT @"important"
#define XN_CS_MYCUSTOMER_ITEM_EASEMOBACCT @"easemobAcct"
#define XN_CS_MYCUSTOMER_ITEM_FREECUSTOMER @"freecustomer"
#define XN_CS_MYCUSTOMER_ITEM_IMAGE @"headImage"
#define XN_CS_MYCUSTOMER_ITEM_FIRSTLETTER @"firstLetter"
#define XN_CS_MYCUSTOMER_ITEM_READFLAG  @"isRead"

#define XN_CS_MYCUSTOMER_ITEM_CURRENTINVESTAMT @"currInvestAmt"

#define XN_CS_MYCUSTOMER_ITEM_NEW_REGIST @"newRegist"
#define XN_CS_MYCUSTOMER_ITEM_SYSIMPFLAG @"sysImpFlag"


/*** 4.5.0 新的模型字段 **/
#define XN_CS_MYCUSTOMER_ITEM_GRADE @"grade"
#define XN_CS_MYCUSTOMER_HEADIMAGE @"headImage"
#define XN_CS_MYCUSTOMER_RECENTTRANDATE @"recentTranDate" 
#define XN_CS_MYCUSTOMER_USERNAME @"userName"


@interface XNCSMyCustomerItemMode : NSObject


@property (nonatomic, strong) NSString * customerId;
@property (nonatomic, strong) NSString * customerName;
@property (nonatomic, strong) NSString * customerMobile;
@property (nonatomic, strong) NSString * registerTime;
@property (nonatomic, strong) NSString * nearInvestAmount;
@property (nonatomic, strong) NSString * nearInvestDate;
@property (nonatomic, strong) NSString * nearEndDate;
@property (nonatomic, strong) NSString * totalInvestAmount;
@property (nonatomic, strong) NSString * totalInvestCount;
@property (nonatomic, assign) BOOL       importantCustomer;
@property (nonatomic, strong) NSString * easeMobPassword;
@property (nonatomic, strong) NSString * freeCustomer;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, assign) BOOL       readFlag;

@property (nonatomic, assign) BOOL       sysImpFlag;
@property (nonatomic, strong) NSString * easeMobAccount;
@property (nonatomic, assign) BOOL       newRegist;

+ (instancetype )initMyCustomerWithObject:(NSDictionary *)params;

@end
