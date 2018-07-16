//
//  XNCommonMsgItemMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNCommonMsgItemMode.h"

@implementation XNCommonMsgItemMode

+ (instancetype)initCommonMsgWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNCommonMsgItemMode * pd = [[XNCommonMsgItemMode alloc]init];
        
        pd.appType = [params objectForKey:XN_MESSAGE_COMMON_APP_TYPE];
        pd.createTime = [params objectForKey:XN_MESSAGE_COMMON_CREATETIME];
        pd.msgId = [params objectForKey:XN_MESSAGE_COMMON_MSG_ID];
        pd.link = [params objectForKey:XN_MESSAGE_COMMON_LINK];
        pd.content = [params objectForKey:XN_MESSAGE_COMMON_CONTENT];
        pd.modifyTime = [params objectForKey:XN_MESSAGE_COMMON_MODIFYTIME];
        pd.isRead = [[params objectForKey:XN_MESSAGE_COMMON_READ] integerValue] == 0?NO:YES;
        pd.startTime = [params objectForKey:XN_MESSAGE_COMMON_STARTTIME];
        pd.status = [params objectForKey:XN_MESSAGE_COMMON_STATUS];
        
        return pd;
    }
    return nil;
}

@end
