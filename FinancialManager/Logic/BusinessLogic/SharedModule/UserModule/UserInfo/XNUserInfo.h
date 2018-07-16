//
//  XNUserInfo.h
//  FinancialManager
//
//  Created by xnkj on 15/11/4.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*  "cfpBenormalTime":"2015-09-11 10:19:33",//理财师转正时间
 "cfpLevel":"2",//理财师级别(1试用期理财师,2实习期理财师,3初级理财师,4中级理财师,5高级理财师,6SENIOR资深理财师,7超级理财师)
 "cfpLevelName":"实习期理财师",//理财师级别名称
 "cfpRegTime":"2015-09-11 10:19:33",//理财师注册时间
 "cfpUpdateTime":"",//升级时间
 "mobile":"15889612375",//手机号
 "userName":"林慧彬",//姓名
 "partnerLevel":"",//合伙人级别(1合伙人,2高级合伙人,3资深合伙人)
 "partnerLevelName":"",//合伙人级别名称
 "partnerRegTime":"",//合伙人注册时间
 "partnerUpTime":""//合伙人升级时间
 "easemobAcct":"3e5e57fc05d0581d4b2efdd0266623bf1451894",//环信帐号
 "easemobPassword":"Rt3K4sPtbihxDI6mHDRwhroMuIU=",//环信密码
*/

#define XN_USERINFO_CFGBENORMAL_TIME @"cfpBenormalTime"
#define XN_USERINFO_CFGLEVEL @"cfpLevel"
#define XN_USERINFO_CFGLEVELNAME @"cfpLevelName"
#define XN_USERINFO_CFGREGTIME @"cfgRegTime"
#define XN_USERINFO_CFGUPDATETIME @"cfgUpdateTime"
#define XN_USERINFO_MOBILE @"mobile"
#define XN_USERINFO_USERNAME @"userName"
#define XN_USERINFO_PARTNERLEVEL @"partnerLevel"
#define XN_USERINFO_PARTNERLEVELNAME @"partnerLevelName"
#define XN_USERINFO_PARTNERREGTIME @"partnerRegTime"
#define XN_USERINFO_PARTNERUPTIME @"partnerUpTime"
#define XN_USERINFO_EASEMOBACCT @"easemobAcct"
#define XN_USERINFO_EASEMOBPASSWORD @"easemobPassword"

@interface XNUserInfo : NSObject

@property (nonatomic, strong) NSString * cfgBeNormalTime;
@property (nonatomic, strong) NSString * cfgLevel;
@property (nonatomic, strong) NSString * cfgLevelName;
@property (nonatomic, strong) NSString * cfgRegTime;
@property (nonatomic, strong) NSString * cfgUpdateTime;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * partnerLevel;
@property (nonatomic, strong) NSString * partnerlevelName;
@property (nonatomic, strong) NSString * partnerRegTime;
@property (nonatomic, strong) NSString * partnerUpdateTime;
@property (nonatomic, strong) NSString * easemobAccount;
@property (nonatomic, strong) NSString * easemobPassword;

+ (instancetype )initUserWithObject:(NSDictionary *)params;
@end
