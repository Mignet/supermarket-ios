//
//  EnvSwitchManager.m
//  FinancialManager
//
//  Created by xnkj on 27/07/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "EnvSwitchManager.h"
#import "JHttpsClient.h"
#import "JHttpClient.h"

@interface EnvSwitchManager()

@property (nonatomic, strong) JHttpClient * httpClient;
@property (nonatomic, strong) JHttpsClient * httpsClient;
@end

@implementation EnvSwitchManager

+ (id)sharedClient {
    static EnvSwitchManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[EnvSwitchManager alloc] init];
        
#if APP_OPEN_HTTPS_ENVIRONMENT
        _sharedClient.httpsClient = [JHttpsClient sharedClient];
#else 
        _sharedClient.httpClient = [JHttpClient sharedClient];
#endif
    });

#if APP_OPEN_HTTPS_ENVIRONMENT
    return _sharedClient.httpsClient;
#else
    return _sharedClient.httpClient;
#endif
    
}

@end
