//
//  UserSignMsgInfoModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "UserSignMsgInfoModel.h"

@implementation UserSignMsgInfoModel

+ (instancetype)userSignMsgInfoModelWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        UserSignMsgInfoModel * pd = [[UserSignMsgInfoModel alloc] init];
        
        pd.extend1 = [params objectForKey:User_Sign_Msg_Info_Model_extend1];
        pd.extend2 = [params objectForKey:User_Sign_Msg_Info_Model_extend2];
        pd.id = [params objectForKey:User_Sign_Msg_Info_Model_id];
        pd.redpacketId = [params objectForKey:User_Sign_Msg_Info_Model_redpacketId];
        pd.shareStatus = [params objectForKey:User_Sign_Msg_Info_Model_shareStatus];
        pd.signAmount = [params objectForKey:User_Sign_Msg_Info_Model_signAmount];
        pd.signDate = [params objectForKey:User_Sign_Msg_Info_Model_signDate];
        pd.signTime = [params objectForKey:User_Sign_Msg_Info_Model_signTime];
        pd.timesAmount = [params objectForKey:User_Sign_Msg_Info_Model_timesAmount];
        pd.timesType = [params objectForKey:User_Sign_Msg_Info_Model_timesType];
        pd.updateTime = [params objectForKey:User_Sign_Msg_Info_Model_updateTime];
        pd.userId = [params objectForKey:User_Sign_Msg_Info_Model_userId];
        pd.userType = [params objectForKey:User_Sign_Msg_Info_Model_userType];
        
        return pd;
    }
    return nil;
}

@end
