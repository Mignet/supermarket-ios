//
//  XNInterfaceController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNInterfaceController.h"
#import "WebViewJavascriptBridge.h"

@interface XNInterfaceController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSString * requestMethod;
@property (nonatomic, strong) NSString * urlStr;

@property (nonatomic, strong) WebViewJavascriptBridge * bridge;
@end

@implementation XNInterfaceController

- (id)initRequestUrl:(NSString *)url requestMethod:(NSString *)requestMethod
{
    self = [super init];
    if (self) {
        
        self.requestMethod = requestMethod;
        self.urlStr = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_bridge setWebViewDelegate:nil];
}

///////////////////////////
#pragma mark - Custom Method
//////////////////////////////////


#pragma mark - 初始化
- (void)initSubView
{
    [self.view addSubview:self.webView];
    
    weakSelf(weakSelf)
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [self loadWebViewWithUrl:self.urlStr];
    [self setupListenEvents];
}

#pragma mark - 更新url
- (void)loadWebViewWithUrl:(NSString *)url
{
    NSString * composeUrl = @"";
    if ([[url componentsSeparatedByString:@"?"] count] >= 2) {
        
        composeUrl = [NSString stringWithFormat:@"%@&key=channel_ios",url];
    }else
        composeUrl = [NSString stringWithFormat:@"%@?key=channel_ios",url];
    
    if ([NSObject isValidateInitString:composeUrl]) {
        
        NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:composeUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:WEBVIEWREQUESTTIMEOUT];
        
        [self.webView loadRequest:request];
    }
}

#pragma mark - 监听事件（由js中调用)
- (void)setupListenEvents
{
    //分享操作
    [self.bridge registerHandler:@"getAppShareFunction" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self sharedOperation:data];
        
        responseCallback(@{@"key":@"finished"});
    }];
    
    //退出操作
    [self.bridge registerHandler:@"getAppLogOut" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:[NSNumber numberWithInteger:ILoginSourceMax]];
        
        responseCallback(@{@"key":@"finished"});
    }];
}

#pragma mark - 默认发送给js方法
- (void)setupJSEvents
{
    //调用js代码传递token过去
    NSString * sendTokenJs = [NSString stringWithFormat:@"getAppToken('%@','%@')",[NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]],@"ios"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:sendTokenJs];
}

#pragma mark - 加载页面标题
- (void)loadWebViewTitle
{
    NSString * js = @"document.title";
    
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:js];
}

#pragma mark - 重新加载网页
- (void)reLoadWebView
{
    [self hideLoadingTarget:self];
    
    [self loadWebViewWithUrl:self.urlStr];
}

////////////////////////
#pragma mark - Protocol
/////////////////////////////////////////

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * requestUrl = [[request URL] absoluteString];
        
    //如果token失效，则弹出登入界面
    if ([requestUrl isEqualToString:@"http://mchannel.xiaoniuapp.com/pages/user/login.html"]) {
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:[NSNumber numberWithInteger:ILoginSourceMax]];
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadWebViewTitle];
    [self setupJSEvents];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [self showNetworkLoadingFailedDidReloadTarget:self Action:@selector(reLoadWebView)];
}

//////////////////////////
#pragma mark - setter/getter
//////////////////////////////////

#pragma mark - webView
- (UIWebView *)webView
{
    if (!_webView) {
        
        _webView = [[UIWebView alloc]init];
    }
    return _webView;
}

#pragma mark - bridge
- (WebViewJavascriptBridge *)bridge
{
    if (!_bridge) {
        
        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
        [_bridge setWebViewDelegate:self];
    }
    return _bridge;
}

@end
