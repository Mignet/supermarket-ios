//
//  SignStatisticsModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Sign_Statistics_Model_dissatisfyDescription @"dissatisfyDescription"
#define Sign_Statistics_Model_firstSignTime @"firstSignTime"
#define Sign_Statistics_Model_leftBouns @"leftBouns"
#define Sign_Statistics_Model_totalBouns @"totalBouns"
#define Sign_Statistics_Model_transferBouns @"transferBouns"
#define Sign_Statistics_Model_transferedBouns @"transferedBouns"
#define Sign_Statistics_Model_userName @"userName"

@interface SignStatisticsModel : NSObject

/*** 不符合转出条件描述 **/
@property (nonatomic, copy) NSString *dissatisfyDescription;

/*** 首次签到时间 **/
@property (nonatomic, copy) NSString *firstSignTime;

/*** 剩余奖励金 **/
@property (nonatomic, copy) NSString *leftBouns;

/*** 总奖励金 **/
@property (nonatomic, copy) NSString *totalBouns;

/*** 可转奖励金 **/
@property (nonatomic, copy) NSString *transferBouns;

/*** 已转金额 **/
@property (nonatomic, copy) NSString *transferedBouns;

/*** 用户姓名 **/
@property (nonatomic, copy) NSString *userName;

+ (instancetype)signStatisticsModelWithParams:(NSDictionary *)params;

@end
