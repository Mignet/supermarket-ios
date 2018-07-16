//
//  XNLCLevelPrivilegeMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 6/29/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XNLC_MODE_CFP_LEVEL_TITLE_NEW @"cfpLevelTitleNew"
#define XNLC_MODE_LOWER_LEVEL_CFP_ACTUAL_NEW @"lowerLevelCfpActualNew"
#define XNLC_MODE_LOWER_LEVEL_CFP_MAX_NEW @"lowerLevelCfpMaxNew"
#define XNLC_MODE_LOWER_LEVEL_CFP @"lowerLevelCfp"
#define XNLC_MODE_YEARPUR_AMOUNT_ACTUAL_NEW @"yearpurAmountActualNew"
#define XNLC_MODE_YEARPUR_AMOUNT_MAX_NEW @"yearpurAmountMaxNew"

#define XNLC_MODE_CFP_LEVEL_CONTENT @"cfpLevelContent"
#define XNLC_MODE_CFP_LEVEL_DETAIL @"cfpLevelDetail"
#define XNLC_MODE_JOB_GRADE @"jobGrade"
#define XNLC_MODE_JOB_GRADE_DESC @"jobGradeDesc"

@interface XNLCLevelPrivilegeMode : NSObject

@property (nonatomic, copy) NSString *cfpLevelTitleNew; //下月晋级xx进度
@property (nonatomic, copy) NSString *lowerLevelCfpActualNew; //实际下级理财师人数
@property (nonatomic, copy) NSString *lowerLevelCfpMaxNew; //直接下级理财师最大人数
@property (nonatomic, copy) NSString *lowerLevelCfp; //直接下级理财师职级
@property (nonatomic, copy) NSString *yearpurAmountActualNew; //实际年化业绩
@property (nonatomic, copy) NSString *yearpurAmountMaxNew; //年化业绩最大金额

@property (nonatomic, copy) NSString *cfpLevelContent; //职级内容(距离下月升级顾问：)
@property (nonatomic, copy) NSString *cfpLevelDetail; //职级详情1(个人年化业绩：还差10000元|直接下级理财师：还差1名经理)
@property (nonatomic, copy) NSString *jobGrade; //当前职级；例：TA,SM1,SM2,SM3
@property (nonatomic, copy) NSString *jobGradeDesc; //当前职级描述；例：见习

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
