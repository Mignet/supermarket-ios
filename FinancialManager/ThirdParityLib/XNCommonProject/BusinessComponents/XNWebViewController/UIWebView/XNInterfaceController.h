//
//  XNInterfaceController.h
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"
#import "WebViewJavascriptBridge.h"
#import "WVHandleBridgeEventManager.h"

@interface XNInterfaceController : BaseViewController

@property (nonatomic, strong) WVHandleBridgeEventManager * handleBridgeEventManager;
@property (nonatomic, strong) WebViewJavascriptBridge * bridge;
@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, assign) BOOL reRefreshPage;//是否需要重新刷新web页面
@property (nonatomic, assign) BOOL forceRefreshPage;//针对爱心公益每个页面都强制刷新
@property (nonatomic, strong) NSString * titleName;//固定死的标题名
@property (nonatomic, assign) BOOL hidenThirdAgentHeaderElement;//隐藏第三方头部

/**
 * 初始化webview
 *
 *  params url 请求的url
 *  params requestMethod 请求方法
 **/
- (id)initRequestUrl:(NSString *)url requestMethod:(NSString *)requestMethod;

- (id)initRequestUrl:(NSString *)url httpBody:(NSString *)body requestMethod:(NSString *)requestMethod;

/**
 * 加载url
 *
 * parmas url 被加载的url
 **/
- (void)loadWebViewWithUrl:(NSString *)url;

/**
 * 是否新起一个webview
 *
 * params newWebView 是否新起一个webview
 *
 **/
- (void)setNewWebView:(BOOL)newWebView;

/**
 * 清除缓存
 *
 **/
- (void)cleanCacheAndCookie;

/**
 * 跳转到新的webview
 *
 * params url 新的url
 **/
- (BOOL)webViewShouldStartLoadWithRequest:(NSString *)url;

//是否跳转到第三方平台
- (void)setIsEnterThirdPlatform:(BOOL)isEnterThirdPlatform platformName:(NSString *)platName;

//隐藏第三方页面相关元素
- (void)hiddenElement;
@end
