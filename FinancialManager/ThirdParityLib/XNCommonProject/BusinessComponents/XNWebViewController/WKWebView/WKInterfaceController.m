//
//  WKInterfaceController.m
//  FinancialManager
//
//  Created by xnkj on 23/12/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "WKInterfaceController.h"

#define TIMEOUT 60.0f

@interface WKInterfaceController()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>

@property (nonatomic, assign) BOOL reRefreshPage;//是否需要重新刷新web页面
@property (nonatomic, assign) BOOL newWebKit;//是否新起一个webkit

@property (nonatomic, copy) NSString * requestUrl;//请求的url
@property (nonatomic, copy) NSString * requestMethod;//请求的方法
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;//网页缓存策略
@property (nonatomic, copy) NSString * currentWebPageUrl;//当前网页的url
@end

@implementation WKInterfaceController

#pragma mark - 生命周期

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
               cachePolicy:(NSURLRequestCachePolicy)policy
{
    self = [super init];
    if (self) {
        
        self.requestUrl = baseUrl;
        self.requestMethod = method;
        self.cachePolicy = policy;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.reRefreshPage) {
        
        self.reRefreshPage = NO;
        
        [self loadWebRequestUrl:self.currentWebPageUrl];
    }
}

#pragma mark - 自定义方法

/**
 * 初始化操作
 *
 **/
- (void)initView
{
    self.newWebKit = NO;
    self.currentWebPageUrl = self.requestUrl;
    
    //禁止长按链接弹框
    [self executeJsString:@"document.documentElement.style.webkitTouchCallout='none';"
        completionHandler:nil];
    
    [self.view addSubview:self.webView];
    
    weakSelf(weakSelf)
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self loadWebRequestUrl:self.requestUrl];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

/**
 * 加载url网页
 *
 * params url 被网页加载的网页url
 *
 **/
- (void)loadWebRequestUrl:(NSString *)url
{
    if ([NSObject isValidateInitString:url]) {
        
        NSMutableURLRequest * request = nil;
        NSString * composeUrl = url;
        
        NSRange existHtmlRange = [url rangeOfString:@"key=channel_ios"];
        if (existHtmlRange.location == NSNotFound) {
            
            if ([[url componentsSeparatedByString:@"?"] count] >= 2) {
                
                composeUrl = [NSString stringWithFormat:@"%@&key=channel_ios",url];
            }else
                composeUrl = [NSString stringWithFormat:@"%@?key=channel_ios",url];
        }

        if (![NSObject isValidateInitString:self.requestMethod] || ![[self.requestMethod uppercaseString] isEqualToString:@"POST"]) {
            
            request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                               timeoutInterval:TIMEOUT];
        }else
        {
            //取body数据
            NSArray * urlComponentArray = [url componentsSeparatedByString:@"?"];
            NSString * bodyStr = urlComponentArray.count >=2 ? [urlComponentArray lastObject]:@"";
            
            [request setHTTPMethod:self.requestMethod];
            [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [self.webView loadRequest:request];
    }
}

/**
 * 加载标题
 *
 **/
- (void)loadTitle
{
    NSString * js = @"document.title";
    
    weakSelf(weakSelf)
    [self executeJsString:js completionHandler:^(id  _Nullable obj, NSError * _Nullable error) {
        
        weakSelf.title = [[NSString stringWithFormat:@"%@",obj] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }];
}

/**
 * 执行js代码
 *
 *  params jsStr 被执行的js字符串
 *
 **/
- (void)executeJsString:(NSString *)jsStr completionHandler:(void(^)(id _Nullable obj, NSError * _Nullable error))completionHandle
{
    [self.webView evaluateJavaScript:jsStr
                   completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                       
                       if (completionHandle)
                          completionHandle(obj,error);
                   }];
}

/**
 * webview中注册供JS调用的方法
 *
 *  params scriptMessageHandler 代理回调。当js调用对应注册的方法后，oc会调用scriptMessageHandle回调方法
 *  params name 注册的方法名
 *
 **/
- (void)registerOCBridgeJSMethodName:(NSString *)name scriptMessageHandle:(id<WKScriptMessageHandler>)scriptMessageHandler
{
    [self.webView.configuration.userContentController addScriptMessageHandler:scriptMessageHandler
                                                                         name:name];
}

/**
 * 清除浏览器缓存
 *
 **/
- (void)clearWebKitCache
{
    //清除cookie
    NSHTTPCookie * cookie = nil;
    NSHTTPCookieStorage * storage = nil;

    storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        
        [storage deleteCookie:cookie];
    }
    
    //清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}

/**
 * 返回操作
 **/
- (void)clickBack:(UIButton *)sender
{
    BOOL goBack = [self.webView canGoBack];
    if (goBack) {
        
        [self.webView goBack];
        
        return;
    }

    [_UI popViewControllerFromRoot:YES];
}

/**
 * 设置是否需要新起一个web
 *
 * params newWebView 是否新起一个webkit
 **/
- (void)setAllocNewWebKit:(BOOL)newWebKit
{
    self.newWebKit = newWebKit;
}

/**
 * 设置是否是否需要设置重新刷新
 *
 * params reRefreshPage 重新刷新的状态
 **/
- (void)setRefreshPageStatus:(BOOL)reRefreshPage
{
    self.reRefreshPage = reRefreshPage;
}

#pragma mark - 协议回调

/*!
 \chinese
 发送请求之前，决定是否跳转
 
 \englisth
 @abstract Decides whether to allow or cancel a navigation.
 @param webView The web view invoking the delegate method.
 @param navigationAction Descriptive information about the action
 triggering the navigation request.
 @param decisionHandler The decision handler to call to allow or cancel the
 navigation. The argument is one of the constants of the enumerated type WKNavigationActionPolicy.
 @discussion If you do not implement this method, the web view will load the request or, if appropriate, forward it to another application.
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString * requestUrl = webView.URL.absoluteString;
    
    if ([requestUrl isEqualToString:[_LOGIC getComposeUrlWithBaseUrl:[AppFramework getConfig].XN_REQUEST_H5_BASE_URL compose:@"/pages/user/login.html"]]) {
        
        self.reRefreshPage = YES;
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:[NSNumber numberWithInteger:ILoginSourceMax]];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if (self.newWebKit && navigationAction.navigationType == WKNavigationTypeLinkActivated && [requestUrl containsString:@".html"]) {
        
        [self webViewShouldStartLoadWithRequest:requestUrl];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ([requestUrl containsString:@".html"])
       self.currentWebPageUrl = requestUrl;
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

/*!
 \chinese
 当web开始加载的时候，调用此回调
 
 \englisth
 @abstract Invoked when a main frame navigation starts.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
}

/*!
 \中文
 加载的内容开始返回的时候，调用此回调
 
 \englisth
 @abstract Invoked when content starts arriving for the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    
}

/*!
 \chinese
 完成加载的时候，调用此回调
 
 \english
 @abstract Invoked when a main frame navigation completes.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self loadTitle];
}

/*!
 \chinese
 网页加载失败的时候，调用此回调
 
 \englisth
 @abstract Invoked when an error occurs while starting to load data for
 the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}

/*!
 \chinese
 当进行https网络请求，需要进行3次握手的时候调用此回调
 
 \englisth
 @abstract Invoked when the web view needs to respond to an authentication challenge.
 @param webView The web view that received the authentication challenge.
 @param challenge The authentication challenge.
 @param completionHandler The completion handler you must invoke to respond to the challenge. The
 disposition argument is one of the constants of the enumerated type
 NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
 the credential argument is the credential to use, or nil to indicate continuing without a
 credential.
 @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    
}

// runJavaScriptAlert
// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message,打印message信息读取出JS端给你的信息。
// 在原生得到结果后，需要回调给JS，通过completionHandler 回调给JS
// completionHandler 回调的参数和返回值都是空
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    JCLogInfo(@"jlsdjflsdjflsjdflsjdf");
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert"message:@"JS调用alert"preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//    
//    [_UI presentNaviModalViewCtrl:alert animated:YES];
}

#pragma mark - setter/getter

/**
 * webview
 **/
- (WKWebView *)webView
{
    if (!_webView) {
        
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
        
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        [_webView setBackgroundColor:UIColorFromHex(0xEAE7E7)];
    }
    return _webView;
}
@end
