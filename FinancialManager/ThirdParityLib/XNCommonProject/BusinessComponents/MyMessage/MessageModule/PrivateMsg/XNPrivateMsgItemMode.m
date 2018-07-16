//
//  XNCommonMsgItemMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNPrivateMsgItemMode.h"

@implementation XNPrivateMsgItemMode

+ (instancetype)initPrivateMsgWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNPrivateMsgItemMode * pd = [[XNPrivateMsgItemMode alloc]init];

        pd.appType = [params objectForKey:XN_MESSAGE_PRIVATE_APP_TYPE];
        pd.content = [params objectForKey:XN_MESSAGE_PRIVATE_CONTENT];
        pd.createTime = [params objectForKey:XN_MESSAGE_PRIVATE_CREATE_TIME];
        pd.msgId = [params objectForKey:XN_MESSAGE_PRIVATE_MSG_ID];
        pd.modifyTime = [params objectForKey:XN_MESSAGE_PRIVATE_MODIFY_TIME];
        pd.isRead = [[params objectForKey:XN_MESSAGE_PRIVATE_ISREAD] integerValue] == 0?NO:YES;
        pd.startTime = [params objectForKey:XN_MESSAGE_PRIVATE_START_TIME];
        pd.status = [params objectForKey:XN_MESSAGE_PRIVATE_STATUS];
        pd.userNumber = [params objectForKey:XN_MESSAGE_PRIVATE_USER_NUMBER];
        
        return pd;
    }
    return nil;
}

@end
