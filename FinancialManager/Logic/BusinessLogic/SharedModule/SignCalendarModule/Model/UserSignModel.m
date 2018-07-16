//
//  UserSignModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "UserSignModel.h"

@implementation UserSignModel

+ (instancetype)userSignModelWithParams:(NSDictionary *)params;
{
    if ([NSObject isValidateObj:params]) {
        
        UserSignModel * pd = [[UserSignModel alloc] init];
        
        pd.bonus = [params objectForKey:User_Sign_Model_bonus];
        pd.times = [params objectForKey:User_Sign_Model_times];
        pd.timesBonus = [params objectForKey:User_Sign_Model_timesBonus];
        
        return pd;
    }
    return nil;
}

@end
