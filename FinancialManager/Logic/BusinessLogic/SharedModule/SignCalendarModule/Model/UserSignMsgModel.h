//
//  UserSignMsgModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserSignMsgInfoModel;

#define User_Sign_Msg_Model_ConsecutiveDays @"consecutiveDays"
#define User_Sign_Msg_Model_HasSigned @"hasSigned"
#define User_Sign_Msg_Model_SignInfo @"signInfo"
#define User_Sign_Msg_Model_Times @"times"

@interface UserSignMsgModel : NSObject

/*** 连续签到天数 **/
@property (nonatomic, copy) NSString *consecutiveDays;

/*** 今日是否签到 true:已签 false:未签 **/
@property (nonatomic, copy) NSString *hasSigned;

@property (nonatomic, strong) UserSignMsgInfoModel *signInfo;

/*** 倍数 **/
@property (nonatomic, copy) NSString *times;

+ (instancetype)userSignMsgInfoModelParams:(NSDictionary *)params;

@end

/***
 data =     {
 consecutiveDays = 1;
 hasSigned = 1;
 signInfo =         {
 extend1 = "";
 extend2 = "";
 id = 19;
 redpacketId = "";
 shareStatus = 0;
 signAmount = "0.11";
 signDate = "2017-11-23 00:00:00";
 signTime = "2017-11-23 09:28:17";
 timesAmount = "";
 timesType = "";
 updateTime = "2017-11-23 09:28:16";
 userId = 822b71784d6f497cb891626fac538a14;
 userType = 1;
 };
 times = 0;
 };

**/
