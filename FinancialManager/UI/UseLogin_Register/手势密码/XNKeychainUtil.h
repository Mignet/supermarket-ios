//
//  XNKeychainUtil.h
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/24/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNKeychainUtil : NSObject

// 手势密码
+ (BOOL)saveGesturePassword:(NSString *)gesturePassword ServerName:(NSString *)serverName;
+ (BOOL)clearGesturePassword;
+ (NSString *)gesturePasswordFromKeychain:(NSString *)serverName;
+ (void)saveGesturePasswordEnabled:(BOOL)enabled;
+ (BOOL)gesturePasswordEnabled;

#pragma mark - uuid
+ (NSString *)udid;

@end
