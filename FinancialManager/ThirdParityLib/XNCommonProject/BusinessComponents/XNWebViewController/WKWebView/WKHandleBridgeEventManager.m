//
//  WKHandleBridgeEventManager.m
//  FinancialManager
//
//  Created by xnkj on 09/01/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "WKHandleBridgeEventManager.h"
#import "SharedViewController.h"
#import "WKUniversalWebViewController.h"

#import "XNFinancialManagerModule.h"
#import "XNFinancialManagerModuleObserver.h"

#import "UINavigationItem+Extension.h"

@interface WKHandleBridgeEventManager()<SharedViewControllerDelegate,XNFinancialManagerModuleObserver>

@property (nonatomic, assign) BOOL                   existSharedView;//是否已经存在分享视图

@property (nonatomic, strong) SharedViewController * sharedCtrl; //分享控件
@end

@implementation WKHandleBridgeEventManager

#pragma mark - cycle

- (id)init
{
    self = [super init];
    if (self) {
        
        [self initManager];
    }
    return self;
}

#pragma mark - 自定义方法

//初始化
- (void)initManager
{
    self.existSharedView = NO;
}

/**
 * web分享
 *
 * params data web传递过来的分享信息
 **/
- (void)getAppShareFunction:(NSDictionary *)data
{
    self.sharedDictionary = [NSDictionary dictionaryWithDictionary:data];
    
    if (!self.existSharedView) {
        
        self.existSharedView = YES;
        
        [self.mainWebViewController.view addSubview:self.sharedCtrl.view];
        [self.mainWebViewController addChildViewController:self.sharedCtrl];
        
        weakSelf(weakSelf)
        [self.sharedCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.mainWebViewController.view);
        }];
        
        [self.mainWebViewController.view layoutIfNeeded];
    }
    
    [self.sharedCtrl show];
}

/**
 * 设置系统分享内容字典
 */
- (void)setNativeSharedDictionary:(NSDictionary *)sharedDictionary
{
    self.sharedDictionary = sharedDictionary;
    
    if (!self.existSharedView) {
        
        self.existSharedView = YES;
        [self.mainWebViewController.navigationItem addShareButtonItemWithTarget:self action:@selector(clickSharedAction)];
        
        [self.mainWebViewController.view addSubview:self.sharedCtrl.view];
        [self.mainWebViewController addChildViewController:self.sharedCtrl];
        
        weakSelf(weakSelf)
        [self.sharedCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(weakSelf.mainWebViewController.view);
        }];
        
        [self.mainWebViewController.view layoutIfNeeded];
    }
}


/**
 * 点击分享弹出分享
 **/
- (void)clickSharedAction
{
    //是否是产品分享
    if ([NSObject isValidateInitString:self.productId]) {
       
        [[XNFinancialManagerModule defaultModule] fmGetSharedProductInfoWithProductId:self.productId];
        [self.mainWebViewController.view showGifLoading];
    }else
    {
        [self.sharedCtrl show];
    }
}

/**
 * 退出操作
 **/
- (void)getAppLogOut
{
    [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
    [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:[NSNumber numberWithInteger:ILoginSourceMax]];
}

/**
 * 获取app的token
 **/
- (void)getAppToken
{
    [self.mainWebViewController executeJsString:[NSString stringWithFormat:@"getAppToken('%@','%@')",@"token",@"IOS"] completionHandler:^(id  _Nullable obj, NSError * _Nullable error) {
        
        
    }];
}

/**
 * 提示处理
 *
 * params data 提示内容
 **/
- (void)showAppPrompt:(NSDictionary *)data
{
   [self.mainWebViewController showCustomWarnViewWithContent:[data objectForKey:@"title"]];
}

/**
 * 获取app的版本
 **/
- (void)getAppVersion
{
    
}

#pragma mark - 协议

//产品分享数据回调
- (void)XNFinancialManagerModuleProductSharedDidReceive:(XNFinancialManagerModule *)module{

    [self.mainWebViewController.view hideLoading];
    
    self.sharedDictionary = module.productSharedMode;
    
    [self.sharedCtrl show];
}

- (void)XNFinancialManagerModuleProductSharedDidFailed:(XNFinancialManagerModule *)module{
    
    [self.mainWebViewController.view hideLoading];

    if (module.retCode.detailErrorDic) {
        
        [self.mainWebViewController showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self.mainWebViewController showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//分享回调
- (NSDictionary *)SharedViewControllerDidReceiveSharedParamsWithKey:(SharedType)type
{
    NSString * url = [_LOGIC getComposeUrlWithBaseUrl:[self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_LINK] compose:@"fromApp=liecai&os=ios"];
    
    switch (type) {
        case  WXFriend_SharedType:
        {
            NSString *title = [self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_TITLE];
            NSString* desc = [self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_DESCRIPTION];
            return @{XN_WEIBO_PUBLIC_TITLE: title, XN_WEIBO_PUBLIC_CONTENT: desc, XN_WEIBO_PUBLIC_URL: url,XN_WEIBO_PUBLIC_ICON:[self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_IMGURL]};
        }
            break;
        case WXFriendArea_SharedType:
        {
            NSString *title = [self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_TITLE];
            NSString* desc = [self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_DESCRIPTION];
            return @{XN_WEIBO_PUBLIC_TITLE: title, XN_WEIBO_PUBLIC_CONTENT: desc, XN_WEIBO_PUBLIC_URL: url,XN_WEIBO_PUBLIC_ICON:[self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_IMGURL]};
        }
            break;
        case QQ_SharedType:
        {
            NSString *title = [self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_TITLE];
            NSString* desc = [self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_DESCRIPTION];
            return @{XN_WEIBO_PUBLIC_TITLE: title, XN_WEIBO_PUBLIC_CONTENT: desc, XN_WEIBO_PUBLIC_URL: url,XN_WEIBO_PUBLIC_ICON:[self.sharedDictionary objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_IMGURL]};
        }
            break;
        case Copy_SharedType:
        {
            return @{XN_COPY_CONTENT:url};
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - setter／getter

- (SharedViewController *)sharedCtrl
{
    if (!_sharedCtrl) {
        
        _sharedCtrl = [[SharedViewController alloc]init];
        _sharedCtrl.delegate = self;
    }
    return _sharedCtrl;
}

//保存分享信息字典
- (NSDictionary *)sharedDictionary
{
    if (!_sharedDictionary) {
        
        _sharedDictionary = [[NSDictionary alloc]init];
    }
    return _sharedDictionary;
}
@end
