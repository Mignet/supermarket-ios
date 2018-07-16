//
//  XNConfigMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/30.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/* "aboutme":"http://www.baidu.com",//关于我们的链接地址
 "question":"http://www.baidu.com",//常见问题的链接地址
 "showlevel":"http://www.baidu.com",//查看等级职级介绍的链接地址
 "rcintroduction":"http://www.baidu.com",//邀请理财师规则介绍的链接地址
 "serviceMail":"xnqgz.kf@xiaoniu66.com",//客服邮箱
 "serviceTelephone":"400-998-9090",//客服电话
 "shareLogoIcon":"http://www.baidu.com",//微信分享logo
 "wechatNumber":"xn-qianguanzi"//微信公众号
*/

#define XN_COMMON_CONFIG_ABOUTME @"aboutme"
#define XN_COMMON_CONFIG_QUESTION @"question"
#define XN_COMMON_CONFIG_SHOWLEVEL @"showlevel"
#define XN_COMMON_CONFIG_RCINTRODUCTION @"rcintroduction"
#define XN_COMMON_CONFIG_CFPREGISTERPROTOCOL @"protocol"
#define XN_COMMON_CONFIG_SERVICEMAIL @"serviceMail"
#define XN_COMMON_CONFIG_SERVICETELEPHONE @"serviceTelephone"
#define XN_COMMON_CONFIG_SHARELOGOICON @"shareLogoIcon"
#define XN_COMMON_CONFIG_WECHATNUMBER @"wechatNumber"
#define XN_COMMON_CONFIG_ZFXY @"zfxy"
#define XN_COMMON_CONFIG_BANK_LIMIT_DETAIL @"bankLimitDetail"
#define XN_COMMON_CONFIG_LEVEL_URL @"saleUserLevelUrl"
#define XN_COMMON_CONFIG_IMG_SERVER_URL @"img_server_url"
#define XN_COMMON_CONFIG_KEFU_EASE_MOBILE_NAME @"kefuEasemobileName"
#define XN_COMMON_CONFIG_LCNEWS_URL @"informationUrl"
#define XN_COMMON_CONFIG_LCNEWS_Detail_URL @"informationDetailUrl"
#define XN_COMMON_CONFIG_DOMAIN_URL @"domainUrl"

#define XN_COMMON_CONFIG_RECOMMANDRULE @"recommandRule"
#define XN_COMMON_CONFIG_REDPACKETOPRINSTRUCTION @"redpacketOprInstruction"
#define XN_COMMON_CONFIG_BULLETINDETAILDEFAULTURL @"bulletinDetailDefaultUrl"
#define XN_COMMON_CONFIG_TUTORIAL @"tutorial"
#define XN_COMMON_CONFIG_COMMISSION_CALCULATION_RULE_URL @"commissionCalculationRuleUrl"
#define XN_COMMON_CONFIG_INVESTMENT_STRATEGY @"investmentStrategy"
#define XN_COMMON_CONFIG_FRAME_WEB_URL @"frameWebUrl"
#define XN_COMMON_CONFIG_PLATEFORM_DETAIL_URL @"orgDetailUrl"
#define XN_COMMON_CONFIG_LEAER_RULE_URL @"leaderRule"

@interface XNConfigMode : NSObject

@property (nonatomic, strong) NSString * aboutMeUrl;
@property (nonatomic, strong) NSString * questionUrl;  //常见问题
@property (nonatomic, strong) NSString * showLevelUrl; //职级
@property (nonatomic, strong) NSString * rcIntroductionUrl;
@property (nonatomic, strong) NSString * cfpRegisterProtocol;
@property (nonatomic, strong) NSString * serviceMail;
@property (nonatomic, strong) NSString * serviceTelephone;
@property (nonatomic, strong) NSString * shareLogoIconUrl;
@property (nonatomic, strong) NSString * wechatNumber;
@property (nonatomic, strong) NSString * zfProtocal;
@property (nonatomic, strong) NSString *bankLimitDetail; //银行充值额度明细表
@property (nonatomic, strong) NSString * saleUserlevelUrl;
@property (nonatomic, strong) NSString *imgServerUrl; // 图片服务器地址
@property (nonatomic, strong) NSString *kefuEasemobileName; //客服环信帐号名称
@property (nonatomic, strong) NSString * lcNews;  //资讯
@property (nonatomic, strong) NSString *informationDetailUrl; //默认url链接
@property (nonatomic, strong) NSString * recommandRule; //推荐规则
@property (nonatomic, strong) NSString * redpacketOprInstruction;//红包规则
@property (nonatomic, strong) NSString * bulletinDetailDefaultUrl; //公告默认地址
@property (nonatomic, strong) NSString * tutorial; //一分钟教你猎财
@property (nonatomic, strong) NSString * commissionCalculationRuleUrl; //	佣金计算规则
@property (nonatomic, strong) NSString * investmentStrategy; //猎财攻略
@property (nonatomic, strong) NSString * domainUrl;
@property (nonatomic, strong) NSString *frameWebUrl; //默认静态链接
@property (nonatomic, strong) NSString * plateformDetailUrl;//平台详情url
@property (nonatomic, strong) NSString * leaderRule; //leader奖励规则


+ (instancetype )initConfigWithObject:(NSDictionary *)params;
@end
