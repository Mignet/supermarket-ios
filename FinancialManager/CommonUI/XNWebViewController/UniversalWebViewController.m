//
//  UniversalWebViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UniversalWebViewController.h"

@interface UniversalWebViewController ()<UIWebViewDelegate,UIScrollViewDelegate,SharedViewControllerDelegate>

@property (nonatomic, strong) NSString * urlStr;

@property (nonatomic, weak) IBOutlet UIWebView * webView;
@end

@implementation UniversalWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil requestUrl:(NSString *)url
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.urlStr = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

////////////////////////
#pragma mark - Custom Method
/////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.navigationController.navigationBarHidden = NO;
    
    [self.webView.scrollView setDelegate:self];
    [self loadWebViewWithUrl:self.urlStr];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 更新url
- (void)loadWebViewWithUrl:(NSString *)url
{
    self.urlStr = url;
    if (![url isEqual:[NSNull null]] && ![url isKindOfClass:[NSNull class]] && url != nil) {
        
        NSURLRequest * request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:WEBVIEWREQUESTTIMEOUT];
        
        [self.webView loadRequest:request];
        [self.view showGifLoading];
    }
}

#pragma mark - 加载页面标题
- (void)loadWebViewTitle
{
    NSString * js = @"document.title";
    
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:js];
}

#pragma mark - 重新加载
- (void)reLoadWebView
{
    [self loadWebViewWithUrl:self.urlStr];
}

////////////////////////
#pragma mark - Protocol
/////////////////////////////////////////

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadWebViewTitle];
    
    [self.view hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.view hideLoading];
    [self showNetworkLoadingFailedDidReloadTarget:self Action:@selector(reLoadWebView)];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(universalWebViewController:didScrollToOffset:)]) {
        
        [self.delegate universalWebViewController:self didScrollToOffset:scrollView.contentOffset.y];
    }
}
@end
