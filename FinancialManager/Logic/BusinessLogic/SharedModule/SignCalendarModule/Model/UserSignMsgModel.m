//
//  UserSignMsgModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "UserSignMsgModel.h"

#import "UserSignMsgInfoModel.h"

@implementation UserSignMsgModel

+ (instancetype)userSignMsgInfoModelParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        UserSignMsgModel * pd = [[UserSignMsgModel alloc] init];
        
        pd.consecutiveDays = [params objectForKey:User_Sign_Msg_Model_ConsecutiveDays];
        pd.hasSigned = [params objectForKey:User_Sign_Msg_Model_HasSigned];
        pd.times = [params objectForKey:User_Sign_Msg_Model_Times];
        pd.signInfo = [UserSignMsgInfoModel userSignMsgInfoModelWithParams:[params objectForKey:User_Sign_Msg_Model_SignInfo]];
        
        return pd;
    }
    return nil;

}

@end
