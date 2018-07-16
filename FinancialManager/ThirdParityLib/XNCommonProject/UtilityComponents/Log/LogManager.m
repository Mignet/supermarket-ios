//
//  JFZLogManager.m
//  GXQApp
//
//  Created by ganquan on 11/5/14.
//  Copyright (c) 2014 jinfuzi. All rights reserved.
//

#import "LogManager.h"
#import "LogFormatter.h"
#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "DDFileLogger.h"

@interface LogManager ()

@property (strong, nonatomic) DDFileLogger* fileLogger;

@end

@implementation LogManager

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static LogManager *instance;
    dispatch_once(&once, ^ {
        
        instance = [[LogManager alloc] init];
        
    });
    
    return instance;
}

- (void)initLogger
{
    if (self) {

        LogFormatter *formatter = [[LogFormatter alloc] init];
        
        [[DDASLLogger sharedInstance] setLogFormatter:formatter];
        [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    }
}
@end
