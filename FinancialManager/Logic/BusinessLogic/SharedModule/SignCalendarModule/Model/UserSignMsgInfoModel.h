//
//  UserSignMsgInfoModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define User_Sign_Msg_Info_Model_extend1 @"extend1"
#define User_Sign_Msg_Info_Model_extend2 @"extend2"
#define User_Sign_Msg_Info_Model_id @"id"
#define User_Sign_Msg_Info_Model_redpacketId @"redpacketId"
#define User_Sign_Msg_Info_Model_shareStatus @"shareStatus"
#define User_Sign_Msg_Info_Model_signAmount @"signAmount"
#define User_Sign_Msg_Info_Model_signDate @"signDate"
#define User_Sign_Msg_Info_Model_signTime @"signTime"
#define User_Sign_Msg_Info_Model_timesAmount @"timesAmount"
#define User_Sign_Msg_Info_Model_timesType @"timesType"
#define User_Sign_Msg_Info_Model_updateTime @"updateTime"
#define User_Sign_Msg_Info_Model_userId @"userId"
#define User_Sign_Msg_Info_Model_userType @"userType"

@interface UserSignMsgInfoModel : NSObject

@property (nonatomic, copy) NSString *extend1;
@property (nonatomic, copy) NSString *extend2;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *redpacketId;

/*** 分享状态 1：已分享 0：未分享 **/
@property (nonatomic, copy) NSString *shareStatus;

@property (nonatomic, copy) NSString *signAmount;
@property (nonatomic, copy) NSString *signDate;
@property (nonatomic, copy) NSString *signTime;
@property (nonatomic, copy) NSString *timesAmount;
@property (nonatomic, copy) NSString *timesType;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userType;

+ (instancetype)userSignMsgInfoModelWithParams:(NSDictionary *)params;

@end

/***
 
 signInfo =        
 {
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
 

**/
