//
//  XNFMAgentDetailMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_FM_AGENT_DETAIL_CAPITAL @"capital"
#define XN_FM_AGENT_DETAIL_CITY @"city"
#define XN_FM_AGENT_DETAIL_FEERATE_MAX @"feeRateMax"
#define XN_FM_AGENT_DETAIL_FEERATE_MIN @"feeRateMin"
#define XN_FM_AGENT_DETAIL_ICP @"icp"

#define XN_FM_AGENT_DETAIL_ORG_BACK @"orgBack"
#define XN_FM_AGENT_DETAIL_ORG_LEVEL @"orgLevel"
#define XN_FM_AGENT_DETAIL_ORG_LOGO @"orgLogo"
#define XN_FM_AGENT_DETAIL_ORG_NAME @"orgName"
#define XN_FM_AGENT_DETAIL_ORG_NO @"orgNo"

#define XN_FM_AGENT_DETAIL_ORG_PROFILE @"orgProfile"
#define XN_FM_AGENT_DETAIL_ORG_SECURITY @"orgSecurity"
#define XN_FM_AGENT_DETAIL_ORG_URL @"orgUrl"
#define XN_FM_AGENT_DETAIL_PRODAYS_MAX @"proDaysMax"
#define XN_FM_AGENT_DETAIL_PRODAYS_MIN @"proDaysMin"
#define XN_FM_AGENT_DETAIL_TRUSTEE_SHIP @"trusteeship"
#define XN_FM_AGENT_DETAIL_UPTIME @"upTime"

#define XN_FM_AGENT_DETAIL_DEADLINE_MAX_SELF_DEFINED @"deadLineMaxSelfDefined"
#define XN_FM_AGENT_DETAIL_DEADLINE_MIN_SELF_DEFINED @"deadLineMinSelfDefined"
#define XN_FM_AGENT_DETAIL_DEADLINE_VALUE_TEXT @"deadLineValueText"
#define XN_FM_AGENT_DETAIL_DEADLINE_ORG_ADVERTISES @"orgActivitys"
#define XN_FM_AGENT_DETAIL_DEADLINE_ORG_ADVANTAGE @"orgAdvantage"
#define XN_FM_AGENT_DETAIL_DEADLINE_ORG_PLANNER_STRATEGY @"orgPlannerStrategy"
#define XN_FM_AGENT_DETAIL_DEADLINE_ORG_PRODUCT_TAG @"orgProductTag"
#define XN_FM_AGENT_DETAIL_DEADLINE_ORG_TAG @"orgTag"
#define XN_FM_AGENT_DETAIL_DEADLINE_PLATFORM_ICO @"platformIco"
#define XN_FM_AGENT_DETAIL_DEADLINE_ORG_ISSTATIC_PRODUCT  @"orgIsstaticproduct"

#define XN_FM_AGENT_DETAIL_TEAM_INFOS @"teamInfos"
#define XN_FM_AGENT_DETAIL_DYNAMIC_LIST @"orgDynamicList"
#define XN_FM_AGENT_DETAIL_ENVIRONMENT_LIST @"orgEnvironmentList"
#define XN_FM_AGENT_DETAIL_HONOR @"orgHonor"
#define XN_FM_AGENT_DETAIL_HONOR_LIST @"orgHonorList"
#define XN_FM_AGENT_DETAIL_PAPERS_LIST @"orgPapersList"

#define XN_FM_AGENT_DETAIL_ORG_CERTIFICATES_LIST @"orgCertificatesList"
#define XN_FM_AGENT_DETAIL_PRODUCT_RELEASE_TIME @"productReleaseTime"
#define XN_FM_AGENT_DETAIL_RECHARGE_LIMIT_DESCRIPTION @"rechargeLimitDescription"
#define XN_FM_AGENT_DETAIL_RECHARGE_LIMIT_TITLE @"rechargeLimitTitle"
#define XN_FM_AGENT_DETAIL_RECHARGE_LIMIT_LINK_URL @"rechargeLimitLinkUrl"
#define XN_FM_AGENT_DETAIL_INTEREST_TIME @"interestTime"
#define XN_FM_AGENT_DETAIL_WITHDRAWAL_CHARGES @"withdrawalCharges"
#define XN_FM_AGENT_DETAIL_CASHIN_TIME @"cashInTime"
#define XN_FM_AGENT_DETAIL_INVEST_OTHERS @"investOthers"
#define XN_FM_AGENT_DETAIL_CONTACT @"contact"

#define XN_FM_AGENT_DETAIL_ORG_FEE_RATIO @"orgFeeRatio"
#define XN_FM_AGENT_DETAIL_ORG_FEE_RATIO_LIMIT @"orgFeeRatioLimit"
#define XN_FM_AGENT_DETAIL_SHARE_DESC @"shareDesc"
#define XN_FM_AGENT_DETAIL_SHARE_ICON @"shareIcon"
#define XN_FM_AGENT_DETAIL_SHARE_LINK @"shareLink"
#define XN_FM_AGENT_DETAIL_SHARE_TITLE @"shareTitle"

@interface XNFMAgentDetailMode : NSObject

@property (nonatomic, strong) NSString *capital; //注册资金
@property (nonatomic, strong) NSString *city; //所在城市
@property (nonatomic, strong) NSString *feeRateMax; //最大年化收益
@property (nonatomic, strong) NSString *feeRateMin; //最小年化收益
@property (nonatomic, strong) NSString *icp; //icp备案
@property (nonatomic, strong) NSString *orgBack; //平台背景
@property (nonatomic, strong) NSString *orgLevel; //平台安全评级
@property (nonatomic, strong) NSString *orgLogo; //机构详情图片
@property (nonatomic, strong) NSString *orgName; //平台名称
@property (nonatomic, strong) NSString *orgNo; //平台编码
@property (nonatomic, strong) NSString *orgProfile; //平台简介
@property (nonatomic, strong) NSString *orgSecurity; //安全保障
@property (nonatomic, strong) NSString *orgUrl; //平台访问链接

@property (nonatomic, strong) NSString *proDaysMax; //平台最小产品期限
@property (nonatomic, strong) NSString *proDaysMin; //平台最大产品期限
@property (nonatomic, strong) NSString *trusteeship; //资金托管
@property (nonatomic, strong) NSString *upTime; //上线时间

@property (nonatomic, strong) NSString *deadLineMaxSelfDefined; //产品最大期限天数 自定义显示
@property (nonatomic, strong) NSString *deadLineMinSelfDefined; //产品最小期限天数 自定义显示
@property (nonatomic, strong) NSString *deadLineValueText; //产品期限

@property (nonatomic, strong) NSArray *orgAdvertises; //机构活动宣传

@property (nonatomic, strong) NSString *orgAdvantage; //机构亮点(多个以英文逗号分隔)
@property (nonatomic, strong) NSString *orgPlannerStrategy; //猎财攻略
@property (nonatomic, strong) NSString *orgProductTag; //产品自定义标签(多个以英文逗号分隔)
@property (nonatomic, strong) NSString *orgTag; //机构自定义标签(多个以英文逗号分隔)
@property (nonatomic, strong) NSString *platformIco; //机构Logo(小图标)
@property (nonatomic, assign) NSInteger orgIsstaticproduct; //是否静态产品 (1：是 ,0：否)

@property (nonatomic, strong) NSArray *teamInfos; //团队介绍

@property (nonatomic, strong) NSArray *orgDynamicList; //机构动态
@property (nonatomic, strong) NSArray *orgEnvironmentList; //机构环境图
@property (nonatomic, strong) NSString *orgHonor; //荣誉
@property (nonatomic, strong) NSArray *orgHonorList; //机构荣誉证书
@property (nonatomic, strong) NSArray *orgPapersList; //机构证书

@property (nonatomic, strong) NSArray *orgCertificatesList; //证书列表
@property (nonatomic, strong) NSString *productReleaseTime; //发标时间
@property (nonatomic, strong) NSString *rechargeLimitDescription; //充值限制
@property (nonatomic, strong) NSString *rechargeLimitTitle; //充值限制（标题）
@property (nonatomic, strong) NSString *rechargeLimitLinkUrl; //充值限制（url）
@property (nonatomic, strong) NSString *interestTime; //起息时间
@property (nonatomic, strong) NSString *withdrawalCharges; //提现费用
@property (nonatomic, strong) NSString *cashInTime; //提现到账
@property (nonatomic, strong) NSString *investOthers; //其他
@property (nonatomic, strong) NSString *contact; //客服电话

@property (nonatomic, strong) NSString *orgFeeRatio; //机构佣金率
@property (nonatomic, strong) NSString *orgFeeRatioLimit; //佣金上限提示语
@property (nonatomic, strong) NSString *shareDesc; //分享描述
@property (nonatomic, strong) NSString *shareIcon; //分享图标
@property (nonatomic, strong) NSString *shareLink; //分享链接
@property (nonatomic, strong) NSString *shareTitle; //分享标题

+ (instancetype)initAgentDetailWithObject:(NSDictionary *)params;

@end
