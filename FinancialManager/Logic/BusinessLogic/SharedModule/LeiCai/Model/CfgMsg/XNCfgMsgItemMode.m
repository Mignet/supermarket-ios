//
//  XNCfgMsgMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 10/10/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNCfgMsgItemMode.h"

@implementation XNCfgMsgItemMode

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNCfgMsgItemMode *mode = [[XNCfgMsgItemMode alloc] init];
        mode.crtTime = [params objectForKey:XN_CFG_MSG_MODE_CRT_TIME];
        mode.img = [params objectForKey:XN_CFG_MSG_MODE_IMG];
        mode.sharedIcon = [params objectForKey:XN_CFG_MSG_MODE_ICON];
        mode.sharedLink = [params objectForKey:XN_CFG_MSG_MODE_LINK_URL];
        mode.name = [params objectForKey:XN_CFG_MSG_MODE_NAME];
        mode.newsId = [[params objectForKey:XN_CFG_MSG_MODE_NEWS_ID] integerValue];
        mode.sharedDesc = [params objectForKey:XN_CFG_MSG_MODE_SUMMARY];
        mode.sharedTitle = [params objectForKey:XN_CFG_MSG_MODE_TITLE];
        mode.typeName = [params objectForKey:XN_CFG_MSG_MODE_TYPENAME];
        
        return mode;
    }
    return nil;
}

@end
