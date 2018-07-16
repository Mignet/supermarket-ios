//
//  SignCalendarModule.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/10.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

@class UserSignModel, UserSignMsgModel, SignStatisticsModel, SignRecordListModel, SignShareModel, SignShareInfoModel, SignCalendarModel, SignBounsTransferModel, InvestStatisticsModel;

@interface SignCalendarModule : AppModuleBase

/*** 签到 **/
@property (nonatomic, strong) UserSignModel *userSignModel;

/*** 签到信息 **/
@property (nonatomic, strong) UserSignMsgModel *userSignMsgModel;

/*** 签到统计 **/
@property (nonatomic, strong) SignStatisticsModel *signStatisticsModel;

/*** 签到记录 **/
@property (nonatomic, strong) SignRecordListModel *signRecordListModel;

/*** 签到分享 **/
@property (nonatomic, strong) SignShareModel *signShareModel;

/*** 分享信息 **/
@property (nonatomic, strong) SignShareInfoModel *signShareInfoModel;

/*** 签到日历 **/
@property (nonatomic, strong) SignCalendarModel *signCalendarModel;

/*** 奖励金转账户 **/
@property (nonatomic, strong) SignBounsTransferModel *signBounsTransferModel;

/*** 交易日历统计 **/
@property (nonatomic, strong) InvestStatisticsModel *investStatisticsModel;

/*** 回款日历统计 **/
@property (nonatomic, strong) InvestStatisticsModel *rebackStatisticsModel;

+ (instancetype)defaultModule;

/**  推荐平台，产品  4.5.1  /personcenter/recomProductOrg
 *
 *   params  idType         1=产品ID 2 =机构ID
 *   params  productOrgId	产品或机构ID
 *   params  token
 *   params  type	1=我的直推理财师 2 =我的客户
 *   params  userId	推荐给直接理财师或客户的userId
 */

- (void)recommendWithProductOrgId:(NSString *)productOrgId userIdString:(NSString *)userId withType:(NSString *)type IdType:(NSString *)idType;


/** 请求Url  /api/sign/sign/4.5.1 (签到)
 *
 *  params  token
 */
- (void)userSign;


/** 请求Url  /api/sign/info/4.5.1 (签到信息)
 *
 *  params  token
 */
- (void)userSignMessage;

/** 请求Url /api/sign/share/prize/4.5.1  (分享)
 *
 *  params  token
 */
- (void)shareSign;

/** 请求Url  /api/sign/share/info/4.5.1  (分享信息)
 *
 *  params  token
 */
- (void)shareMessage;

/** 请求Url  /api/sign/bouns/transfer/4.5.1 (奖励金转账户)
 *
 *  params  token
 */
- (void)signBounsTransfer;

/** 请求Url  /api/sign/calendar/4.5.1 (签到日历)
 *
 *  params  token
 */
- (void)signCalendarSignTime:(NSString *)signTime;


/** 请求Url  /api/sign/statistics/4.5.1 (签到统计)
 *
 *  params  token
 */
- (void)signStatistics;


/** 请求Url  /api/sign/records/pageList/4.5.1 (签到记录)
 *
 *  params  pageIndex
 *  params  pageSize
 *  params  token
 */
- (void)signRecordsPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;


/**  /api/personcenter/investCalendarStatistics   4.5.1 交易日历统计
 *  
 *  params  investMonth  投资时间
 *  params  token
 *
 */
- (void)investCalendarStatisticsInvestMonth:(NSString *)investMonth;

/**  /api/personcenter/repamentCalendarStatistics   4.5.1 回款日历统计
 *
 *  params  rePaymentMonth  回款月份
 *  params  token
 *
 */

- (void)personcenterRepamentCalendarStatistics:(NSString *)rePaymentMonth;





@end
