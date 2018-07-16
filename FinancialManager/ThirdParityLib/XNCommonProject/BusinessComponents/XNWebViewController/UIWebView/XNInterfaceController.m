//
//  XNInterfaceController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNInterfaceController.h"
#import "UINavigationItem+Extension.h"

@interface XNInterfaceController ()<UIWebViewDelegate>

@property (nonatomic, assign) BOOL firstEnterWebView;//是否是第一次进入webview
@property (nonatomic, assign) BOOL newWebView;//是否新起一个webkit
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, strong) NSString * requestMethod;
@property (nonatomic, strong) NSString * urlStr;
@property (nonatomic, assign) BOOL isEnterThirdPlatform;
@property (nonatomic, strong) NSString * httpBody;
@property (nonatomic, strong) NSString *platformName;

@end

@implementation XNInterfaceController

- (id)initRequestUrl:(NSString *)url requestMethod:(NSString *)requestMethod
{
    self = [super init];
    if (self) {
        
        self.requestMethod = requestMethod;
        self.urlStr = url;
        _isEnterThirdPlatform = NO;
        self.titleName = nil;
        self.hidenThirdAgentHeaderElement = NO;
        self.forceRefreshPage = NO;
    }
    return self;
}

- (id)initRequestUrl:(NSString *)url httpBody:(NSString *)body requestMethod:(NSString *)requestMethod
{
    self = [super init];
    if (self)
    {
        self.requestMethod = requestMethod;
        self.urlStr = url;
        _isEnterThirdPlatform = NO;
        self.httpBody = body;
        self.titleName = nil;
        self.hidenThirdAgentHeaderElement = NO;
        self.forceRefreshPage = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //如果当前存在网页，则进行重新加载
    if ((!self.firstEnterWebView && self.reRefreshPage) || self.forceRefreshPage) {
        
        [self.webView reload];
    }
    self.firstEnterWebView = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view removeGestureRecognizer:self.tapGesture];
}

- (void)dealloc
{
    [_bridge setWebViewDelegate:nil];
}

///////////////////////////
#pragma mark - Custom Method
//////////////////////////////////

//初始化
- (void)initSubView
{
    self.firstEnterWebView = YES;
    self.reRefreshPage = NO;
//    self.newWebView = NO;
    
    [self.webView setBackgroundColor:UIColorFromHex(0xEEEFF3)];
    [self.webView setScalesPageToFit:YES];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];    //禁止长按链接弹框
    
    [self.view addSubview:self.webView];
    
    weakSelf(weakSelf)
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    //获得app的token
    [self.bridge registerHandler:@"getAppToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        responseCallback([NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]]);
    }];
    
    if (_isEnterThirdPlatform)
    {
        [self loadWebViewWithThirdPlatformUrl:self.urlStr];
        [self showGifViewWithContent:[NSString stringWithFormat:@"正在为您跳转至%@", self.platformName]];
        [self.view addGestureRecognizer:self.tapGesture];
    }
    else
    {
        [self loadWebViewWithUrl:self.urlStr];
    }
    
    if (@available(iOS 11.0, *)) {
        
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

//加载url
- (void)loadWebViewWithUrl:(NSString *)url
{
    if ([NSObject isValidateInitString:url]) {
        
        NSMutableURLRequest * request = nil;
        NSString * composeUrl = [self composeUrlWithBase:url];
        
        if (![NSObject isValidateInitString:self.requestMethod] || ![[self.requestMethod uppercaseString] isEqualToString:@"POST"]) {
            
            request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:composeUrl]
                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                               timeoutInterval:WEBVIEWREQUESTTIMEOUT];
            request.HTTPMethod = self.requestMethod;
        }else
        {
            //取body数据
            NSArray * urlComponentArray = [composeUrl componentsSeparatedByString:@"?"];
            NSString * bodyStr = urlComponentArray.count >=2 ? [urlComponentArray lastObject]:@"";
         
            if (urlComponentArray.count > 0) {
                
                request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[urlComponentArray firstObject]]
                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                   timeoutInterval:WEBVIEWREQUESTTIMEOUT];
                
                [request setHTTPMethod:self.requestMethod];
                [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        [self.webView loadRequest:request];
    }
}

//拼装url
- (NSString *)composeUrlWithBase:(NSString *)baseUrl
{
    NSString * composeUrl = baseUrl;
    
    NSRange existHtmlRange = [baseUrl rangeOfString:@"key=channel_ios"];
    if (existHtmlRange.location == NSNotFound) {
        
        if ([[baseUrl componentsSeparatedByString:@"?"] count] >= 2) {
            
            composeUrl = [NSString stringWithFormat:@"%@&key=channel_ios",baseUrl];
        }else
            composeUrl = [NSString stringWithFormat:@"%@?key=channel_ios",baseUrl];
    }

    return composeUrl;
}

#pragma mark - 启动加载第三方平台url
- (void)loadWebViewWithThirdPlatformUrl:(NSString *)url
{
    if ([NSObject isValidateInitString:url])
    {
        NSString *body = self.httpBody;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:url]];
        [request setHTTPMethod:self.requestMethod];
        [request setHTTPBody: [body dataUsingEncoding:NSUTF8StringEncoding]];
        [self.webView loadRequest:request];
    }
}

//向js中传递token
- (void)setupJSEvents
{
    //调用js代码传递token过去
    NSString * sendTokenJs = [NSString stringWithFormat:@"getAppToken('%@','%@')",[NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]],@"ios"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:sendTokenJs];
}

//加载页面标题
- (void)loadWebViewTitle
{
    if ([NSObject isValidateObj:self.titleName]) {
        
        self.title = self.titleName;
        
        return;
    }
    
    NSString * js = @"document.title";
    
    self.title = [[self.webView stringByEvaluatingJavaScriptFromString:js] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

//返回操作
- (void)clickBack:(UIButton *)sender
{
    BOOL goBack = [self.webView canGoBack];
    if (goBack) {
        
        [self.webView goBack];
        return;
    }
    
    [_UI popViewControllerFromRoot:YES];
}

//跳转到新的webview
- (void)setNewWebView:(BOOL)newWebView
{
    _newWebView = newWebView;
}

#pragma mark - 是否跳转到第三方平台
- (void)setIsEnterThirdPlatform:(BOOL)isEnterThirdPlatform platformName:(NSString *)platName
{
    self.platformName = platName;
    _isEnterThirdPlatform = isEnterThirdPlatform;
    
    [self.navigationItem addRightBarItemWithTitle:@"返回猎财大师" titleColor:[UIColor whiteColor] target:self action:@selector(gotoLieCai)];
    
}

#pragma mark - 返回猎财
- (void)gotoLieCai
{
    [_UI popViewControllerFromRoot:YES];
}

//清除缓存
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

//隐藏第三方页面相关元素
- (void)hiddenInsuranceHeaderElement
{
    NSString * js = @"document.getElementsByTagName('header')[0].style['display']='none'";
    
    [[self.webView stringByEvaluatingJavaScriptFromString:js] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

//手势点击操作
- (void)handleGesture:(UITapGestureRecognizer *)tapGesture
{
    [self.view removeGestureRecognizer:self.tapGesture];
    
    if (_isEnterThirdPlatform)
    {
        [self hideGifView];
    }
    
    if (self.hidenThirdAgentHeaderElement) {
        
        [self hiddenInsuranceHeaderElement];
    }
}

////////////////////////
#pragma mark - Protocol
/////////////////////////////////////////

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * requestUrl = [[request URL] absoluteString];
    
    if (self.newWebView && navigationType == UIWebViewNavigationTypeLinkClicked && [requestUrl containsString:@".html"]) {
        
       return [self webViewShouldStartLoadWithRequest:requestUrl];
    }
    
    //针对惠泽保险跳转操作
    if ([[requestUrl stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"https://cps.qixin18.com/m/lq1009128/"]) {
        
        [_UI currentViewController:self popToRootViewController:YES AndSwitchToTabbarIndex:0 comlite:nil];
    }
    
    //针对爱心公益链接做特殊处理（针对进入支付，但是选择取消支付的操作的时候页面被灰色弹出遮盖的问题）
    if ([[requestUrl stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:[[_LOGIC getWebUrlWithBaseUrl:@"/pages/activities/vFund.html?key=channel_ios"] stringByReplacingOccurrencesOfString:@" " withString:@""]] || [[requestUrl stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:[[_LOGIC getWebUrlWithBaseUrl:@"/pages/activities/vFund.html"] stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
        
        self.forceRefreshPage = YES;
    }
    
    //只要触发此回调用，则表示页面有变化了
    [self.handleBridgeEventManager changeCurrentPage];
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadWebViewTitle];
    [self setupJSEvents];
    
    [self handleGesture:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self loadWebViewTitle];
    [self setupJSEvents];
    
    [self handleGesture:nil];
}

//////////////////////////
#pragma mark - setter/getter
//////////////////////////////////

#pragma mark - webView
- (UIWebView *)webView
{
    if (!_webView) {
        
        _webView = [[UIWebView alloc]init];
//        [_webView setScalesPageToFit:YES];
    }
    return _webView;
}

#pragma mark - bridge
- (WebViewJavascriptBridge *)bridge
{
    if (!_bridge) {
        
        [WebViewJavascriptBridge enableLogging];
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
        [_bridge setWebViewDelegate:self];
       
    }
    return _bridge;
}

//通用业务逻辑处理对象
- (WVHandleBridgeEventManager *)handleBridgeEventManager
{
    if (!_handleBridgeEventManager) {
        
        _handleBridgeEventManager = [[WVHandleBridgeEventManager alloc]init];
    }
    return _handleBridgeEventManager;
}

//tapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if(!_tapGesture)
    {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    }
    return _tapGesture;
}
@end
