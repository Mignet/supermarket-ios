//
//  WKHandleBridgeEventManager.h
//  FinancialManager
//
//  Created by xnkj on 09/01/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WKUniversalWebViewController;
@interface WKHandleBridgeEventManager : NSObject

@property (nonatomic, copy) NSDictionary * sharedDictionary;//分享字典
@property (nonatomic, copy) NSString * productId;//用于产品分享的产品id
@property (nonatomic, weak) WKUniversalWebViewController * mainWebViewController;

/**
 * web分享
 *
 * params data web传递过来的分享信心
 **/
- (void)getAppShareFunction:(NSDictionary *)data;

/**
 * native分享
 *
 * params sharedDictionary 分享字典
 **/
- (void)setNativeSharedDictionary:(NSDictionary *)sharedDictionary;

/**
 * 退出操作
 **/
- (void)getAppLogOut;

/**
 * 获取app的token
 **/
- (void)getAppToken;

/**
 * 提示处理
 *
 * params data 提示内容
 **/
- (void)showAppPrompt:(NSDictionary *)data;

/**
 * 获取app的版本
 **/
- (void)getAppVersion;
@end
