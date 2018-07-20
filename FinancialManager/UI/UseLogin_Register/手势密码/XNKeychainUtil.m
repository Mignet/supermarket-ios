//
//  XNKeychainUtil.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/24/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "XNKeychainUtil.h"
#import "SSKeychain.h"

#import <UIKit/UIKit.h>

@implementation XNKeychainUtil

#pragma mark - 手势密码
static NSString *const gesturePasswordService = @"xiaoniuqianguanzi68753";
static NSString *const gesturePasswordAccount = @"xiaoniuqianguanzi68754";
static NSString *const gesturePasswordEnabledKey = @"gesturePasswordEnabledKey";             // 是否启用手势密码关键字

+ (BOOL)saveGesturePassword:(NSString *)gesturePassword ServerName:(NSString *)serverName {
    
    if (gesturePassword) {
        
        [self saveGesturePasswordEnabled:YES];
    }
    return [SSKeychain setPassword:gesturePassword
                        forService:serverName
                           account:gesturePasswordAccount];
}

+ (BOOL)clearGesturePassword {
    
    [self saveGesturePasswordEnabled:NO];
    return [SSKeychain deletePasswordForService:gesturePasswordService
                                        account:gesturePasswordAccount];
}

+ (NSString *)gesturePasswordFromKeychain:(NSString *)serverName {
    
    return [SSKeychain passwordForService:serverName
                                  account:gesturePasswordAccount];
}

+ (BOOL)gesturePasswordEnabled {
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:gesturePasswordEnabledKey] boolValue];
}

+ (void)saveGesturePasswordEnabled:(BOOL)enabled {
    
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    [standard setObject:[NSNumber numberWithBool:enabled] forKey:gesturePasswordEnabledKey];
    [standard synchronize];
}

#pragma mark - uuid
static NSString *const kXNUDIDKeychainService = @"kXNUDIDKeychainService";
static NSString *const kXNUDIDKeychainIdentifier = @"kXNUDIDKeychainIdentifier";

+ (NSString *)udid {
    
    NSString *udid = [SSKeychain passwordForService:kXNUDIDKeychainService
                                            account:kXNUDIDKeychainIdentifier];
    if (!udid) {
        
        udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [SSKeychain setPassword:udid
                     forService:kXNUDIDKeychainService
                        account:kXNUDIDKeychainIdentifier];
    }
    return udid;
}

@end
