//
//  AssistLayer.h
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonReachability.h"

#define NETWORKSTATUS_NOTREACHABLE  "NotReachable"
#define NETWORKSTATUS_WIFI          "ReachableViaWiFi"
#define NETWORKSTATUS_WWAN          "ReachableViaWWAN"

@interface AssistLayer : NSObject

/*查询当前网络状态,
 返回值为xlNotReachable时代表无网络连接,
 返回值为xlReachableViaWiFi时代表WIFI连接,
 返回值为xlReachableViaWWAN时代表3G连接*/
- (NSInteger)getNetworkStatus;

@end
