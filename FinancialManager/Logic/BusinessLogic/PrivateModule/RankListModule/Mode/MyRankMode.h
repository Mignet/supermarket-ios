//
//  MyRankMode.h
//  FinancialManager
//
//  Created by xnkj on 22/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 headImage	头像	string
 mobile	手机号码	string
 rank	我的排名	number
 totalProfit	总收益	string	*/

#define XN_HOME_RANKLIST_MYRANK_HEADIMAGE @"headImg"
#define XN_HOME_RANKLIST_MYRANK_MOBILE @"mobile"
#define XN_HOME_RANKLIST_MYRANK_RANK @"rank"
#define XN_HOME_RANKLIST_MYRANK_TOTALPROFIT @"totalProfit"
#define XN_HOME_RANKLIST_MYRANK_LEVEL_NAME @"levelName"

@interface MyRankMode : NSObject

@property (nonatomic, strong) NSString * headImageStr;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * rank;
@property (nonatomic, strong) NSString * totalProfit;
@property (nonatomic, strong) NSString * levelName;

+ (instancetype)initMyRankWithParams:(NSDictionary *)params;
@end
