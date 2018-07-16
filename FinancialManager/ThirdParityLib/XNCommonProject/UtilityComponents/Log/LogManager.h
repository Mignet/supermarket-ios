//
//  JFZLogManager.h
//  GXQApp
//
//  Created by liaochangping on 11/5/14.
//  Copyright (c) 2014 xiaoliaozi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COMMON_LOG_CONTEXT      (0x01)
#define NETWORK_LOG_CONTEXT     (0x02)

extern int JCLogLevel;
extern int JNLogLevel;

#import "JCommonLog.h"
#import "JNetworkLog.h"

@interface LogManager : NSObject

+ (id)sharedInstance;

- (void)initLogger;
@end
