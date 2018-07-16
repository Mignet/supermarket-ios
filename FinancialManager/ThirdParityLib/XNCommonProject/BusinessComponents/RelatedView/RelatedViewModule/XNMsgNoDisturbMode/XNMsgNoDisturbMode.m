//
//  XNMsgNoDisturbMode.m
//  Lhlc
//
//  Created by ancye.Xie on 3/25/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNMsgNoDisturbMode.h"

@implementation XNMsgNoDisturbMode

+ (instancetype )initWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNMsgNoDisturbMode *mode = [[XNMsgNoDisturbMode alloc] init];
        mode.platformflag = [[params objectForKey:XN_MSG_NO_DISTURB_PLATFORM_FLAG] boolValue];
//        mode.interactflag = [[params objectForKey:XN_MSG_NO_DISTURB_INTERACT_FLAG] boolValue];
        return mode;
    }
    return nil;
}

@end
