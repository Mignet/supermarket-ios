//
//  XNMsgNoDisturbMode.h
//  Lhlc
//
//  Created by ancye.Xie on 3/25/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MSG_NO_DISTURB_PLATFORM_FLAG @"platformflag"
//#define XN_MSG_NO_DISTURB_INTERACT_FLAG @"interactflag"

@interface XNMsgNoDisturbMode : NSObject

@property (nonatomic, assign) BOOL platformflag; //平台消息免打扰是否开启：0-不开启 1-开启免打扰
//@property (nonatomic, assign) BOOL interactflag; //互动消息免打扰是否开启：0-不开启 1-开启免打扰

+ (instancetype )initWithParams:(NSDictionary *)params;

@end
