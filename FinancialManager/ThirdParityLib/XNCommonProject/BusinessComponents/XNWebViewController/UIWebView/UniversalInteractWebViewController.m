//
//  UniversalInteractWebViewController.m
//  FinancialManager
//
//  Created by xnkj on 3/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "UniversalInteractWebViewController.h"
#import "AgentDetailViewController.h"
#import "CustomerChatManager.h"
#import "NewUserGuildController.h"
#import "WVHandleBridgeEventManager.h"

#import "UINavigationItem+Extension.h"

typedef void(^CompletionBlock)(id data);

@interface UniversalInteractWebViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@end

@implementation UniversalInteractWebViewController

- (id)initRequestUrl:(NSString *)url requestMethod:(NSString *)requestMethod
{
    self = [super initRequestUrl:url requestMethod:requestMethod];
    if (self) {
     
        [self.handleBridgeEventManager setDelegateMainWebViewController:self];
    }
    return self;
}

- (id)initRequestUrl:(NSString *)url httpBody:(NSString *)body requestMethod:(NSString *)requestMethod
{
    self = [super initRequestUrl:url httpBody:body requestMethod:requestMethod];
    if (self)
    {
        [self.handleBridgeEventManager setDelegateMainWebViewController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.currentBindCardOperation)
    {
        self.currentBindCardOperation = NO;
        [self.delegate authenticateBindCardSuccess];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[AppFramework getGlobalHandler] removePopupView];
    
    [super viewDidDisappear:animated];
}

- (BOOL)willDealloc
{
    return NO;
}

- (void)dealloc
{
    self.delegate = nil;
}

////////////////////////
#pragma mark - Custom Method
/////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.currentBindCardOperation = NO;
    self.navigationSeperatorLineStatus = YES; 
    
    [self.webView.scrollView setDelegate:self];
    
//    [self.handleBridgeEventManager setNativeSharedDictionary:nil];
    [self.handleBridgeEventManager productDetailRecommend:nil];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

/**
 * 设置产品分享
 *
 * params 分享内容字典
 **/
- (void)setSharedOpertionWithParams:(NSDictionary *)params
{
    [self.handleBridgeEventManager setNativeSharedDictionary:params];
}

/**
 * 设置分享的产品id
 **/
- (void)setSharedProductId:(NSString *)productId
{
    [self.handleBridgeEventManager setSharedProductId:productId];
}

#pragma mark - 设置在线客服
- (void)setCustomerService
{
    [self.navigationItem addRightBarItemWithTitle:@"在线客服" titleColor:[UIColor whiteColor] target:self action:@selector(customerServiceOnChat)];
}

#pragma mark - 进入在线客服
- (void)customerServiceOnChat
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewEnterChat)]) {
        
        [self.delegate webViewEnterChat];
    }
}

#pragma mark - 转流
- (BOOL)webViewShouldStartLoadWithRequest:(NSString *)url
{
    UniversalInteractWebViewController * ctrl = [[UniversalInteractWebViewController alloc] initRequestUrl:url requestMethod:@"GET"];
    
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
    
    return NO;
}

#pragma mark - 新手指引
- (void)loadNewUserGuild:(CGRect )rect
{
//    if ([_LOGIC canShowGuildViewAt:self withKey:XN_USER_PRODUCT_TAG])
//    {
//        NewUserGuildController * userGuildController = [[NewUserGuildController alloc]initWithNibName:@"NewUserGuildController" bundle:nil masksPathArray:@[[[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5] bezierPathByReversingPath]] guildImagesArray:@[[UIImage imageNamed:@"xn_product_desc.png"]] guildImageLocationArray:@[[NSValue valueWithCGRect:CGRectMake((98 * SCREEN_FRAME.size.width) / 375.0, rect.origin.y - 60, 202, 53)]]];
//        
//        [userGuildController setClickCompleteBlock:^{
//            
//            [_LOGIC saveValueForKey:XN_USER_PRODUCT_TAG Value:@"0"];
//        }];
//        
//        [_KEYWINDOW addSubview:userGuildController.view];
//        [self addChildViewController:userGuildController];
//        
//        __weak UIWindow * tmpWindow = [[UIApplication sharedApplication] keyWindow];
//        [userGuildController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.edges.equalTo(tmpWindow);
//        }];
//        
//        [AppFramework getGlobalHandler].currentPopup = userGuildController.view;
//    }
}

/**
 * 产品推荐
 **/
- (void)setProductDetailRecommend:(XNFMProductListItemMode *)productMode
{
    [self.handleBridgeEventManager productDetailRecommend:productMode];
}

/////////////////////
#pragma mark - protocal
////////////////////////////////////////

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(universalWebViewControllerDidScrollToOffset:)]) {
        
        [self.delegate universalWebViewControllerDidScrollToOffset:scrollView.contentOffset.y];
    }
}
@end
