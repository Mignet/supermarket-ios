//
//  WKInterfaceController.h
//  FinancialManager
//
//  Created by xnkj on 23/12/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WKWebView.h>
#import <WebKit/WKUserScript.h>
#import <WebKit/WKScriptMessageHandler.h>
#import <WebKit/WKScriptMessage.h>
#import <WebKit/WKWebViewConfiguration.h>
#import <WebKit/WKUserContentController.h>
#import <WebKit/WKNavigationAction.h>
#import <WebKit/WKNavigationDelegate.h>

@protocol WKScriptMessageHandler;
@interface WKInterfaceController : BaseViewController

@property (nonatomic, strong) WKWebView * webView; //WKWebView

/**
 *  初始化请求
 *
 *  params baseUrl 请求url
 *  params method 请求的方法-post,get,dele.....
 *  params policy 请求的缓存策略
 *
 *  返回对象
 **/
- (id)initWithRequestUrl:(NSString *)baseUrl
           requestMethod:(NSString *)method
             cachePolicy:(NSURLRequestCachePolicy)policy;

/**
 * 加载url请求
 *
 * params url 需要被加载的url
 *
 **/
- (void)loadWebRequestUrl:(NSString *)url;

/**
 * 执行js代码
 *
 *  params jsStr 被执行的js字符串
 *  params completionHandle 回调处理
 *
 **/
- (void)executeJsString:(NSString *)jsStr completionHandler:(void(^)(id _Nullable obj, NSError * _Nullable error))completionHandle;

/**
 * webview中注册供JS调用的方法
 *
 *  params scriptMessageHandler 代理回调。当js调用对应注册的方法后，oc会调用scriptMessageHandle回调方法
 *  params name 注册的方法名
 *
 **/
- (void)registerOCBridgeJSMethodName:(NSString *)name scriptMessageHandle:(id<WKScriptMessageHandler>)scriptMessageHandler;

/**
 * 设置是否需要新起一个web
 *
 * params newWebView 是否新起一个webkit
 **/
- (void)setAllocNewWebKit:(BOOL)newWebKit;

/**
 * web开始启动一个新的url且设置了新启一个webkit的时候触发此方法
 *
 **/
- (BOOL)webViewShouldStartLoadWithRequest:(NSString *)url;

/**
 * 清除浏览器缓存
 *
 **/
- (void)clearWebKitCache;

/**
 * 设置是否需要新起一个web
 *
 * params newWebView 是否新起一个webkit
 **/
- (void)setNewWebKit:(BOOL)newWebKit;

/**
 * 设置是否是否需要设置重新刷新
 *
 * params reRefreshPage 重新刷新的状态
 **/
- (void)setRefreshPageStatus:(BOOL)reRefreshPage;
@end
