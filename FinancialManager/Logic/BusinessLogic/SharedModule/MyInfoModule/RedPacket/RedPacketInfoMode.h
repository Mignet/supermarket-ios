//
//  RedPacketInfoMode.h
//  FinancialManager
//
//  Created by xnkj on 6/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MI_RP_INFO_DATESTR @"expireTime"
#define XN_MI_RP_INFO_SHOWNAME @"name"
#define XN_MI_RP_INFO_REDPAPERCOUNT @"redpacketCount"
#define XN_MI_RP_INFO_REDPAPERMONEY @"redpacketMoney"
#define XN_MI_RP_INFO_USEREMARK @"remark"
#define XN_MI_RP_INFO_RID @"rid"
#define XN_MI_RP_INFO_USERSTATUS @"useStatus"
#define XN_MI_RP_INFO_USERIMAGE @"userImage"
#define XN_MI_RP_INFO_USERMOBILE  @"userMobile"
#define XN_MI_RP_INFO_USERNAME @"userName"

#define XN_MI_RP_INFO_INVEST_LIMIT @"investLimit"
#define XN_MI_RP_INFO_PRODUCT_LIMIT @"productLimit"
#define XN_MI_RP_INFO_PRODUCT_NAME @"productName"
#define XN_MI_RP_INFO_PRODUCT_DEADLINE @"deadline"
#define XN_MI_RP_INFO_IS_PLATFORM_LIMIT @"platformLimit"
#define XN_MI_RP_INFO_PLATFORM @"platform"
#define XN_MI_RP_INFO_CFPIFSEND @"cfpIfSend"
#define XN_MI_PR_INFO_AMOUNTLIMIT @"amountLimit"
#define XN_MI_PR_INFO_AMOUNT @"amount"
#define XN_MI_PR_INFO_SENDSTATUS @"sendStatus"

@interface RedPacketInfoMode : NSObject

@property (nonatomic, strong) NSString * userName; //用户名称
@property (nonatomic, strong) NSString * userMobile; //用户手机号码
@property (nonatomic, strong) NSString * userImage; //用户头像
@property (nonatomic, strong) NSString * redPacketUseStatus; //使用状态(0=未使用|1=已使用|2=已过期)
@property (nonatomic, strong) NSString * redPacketRemark;//红包描述
@property (nonatomic, strong) NSString * redPacketMoney; //红包金额
@property (nonatomic, strong) NSString * redPacketCount; //红包数量
@property (nonatomic, strong) NSString *productName; //产品名称 （产品限制等于1时有效）
@property (nonatomic, assign) NSInteger nProductLimit; //产品限制 0=不限|1=限制产品|2=等于产品期限|3=大于等于产品期限
@property (nonatomic, assign) BOOL isPlatformLimit; //平台限制 true=限制|false=不限制
@property (nonatomic, strong) NSString *platform; //限制平台 平台限制 =true 有效
@property (nonatomic, strong) NSString * redPacketName; //红包名称
@property (nonatomic, assign) NSInteger nInvestLimit; //投资限制 0=不限|1=用户首投|2=平台首投
@property (nonatomic, strong) NSString * expireTime;//过期时间
@property (nonatomic, assign) NSInteger  amountLimit;//金额限制,0表示不限、1表示大于、2表示大于等于
@property (nonatomic, strong) NSString * investAmount;//投资金额
@property (nonatomic, strong) NSString * sendStatus;//0=不可派发|1=可派发
@property (nonatomic, copy) NSString * amount;

@property (nonatomic, strong) NSString * redPacketDateDesc; //过期时间
@property (nonatomic, strong) NSString * productDeadline; //产品期限 产品限制=2|3有效
@property (nonatomic, strong) NSString * cfpIfSend;
@property (nonatomic, strong) NSString * redPacketRid; //红包编号
@property (nonatomic, copy) NSString *name;

+ (instancetype)initRedPacketInfoWithParams:(NSDictionary *)params;
@end

