//
//  UserSignModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define User_Sign_Model_bonus @"bonus"
#define User_Sign_Model_times @"times"
#define User_Sign_Model_timesBonus @"timesBonus"

@interface UserSignModel : NSObject

//bonus	奖励金	string
@property (nonatomic, copy) NSString *bonus;

//times	连续签到倍数	number
@property (nonatomic, copy) NSString *times;

//timesBonus	连续签到翻倍奖励金	string
@property (nonatomic, copy) NSString *timesBonus;

+ (instancetype)userSignModelWithParams:(NSDictionary *)params;

@end
