//
//  WKUniversalWebViewController.m
//  FinancialManager
//
//  Created by xnkj on 09/01/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "WKUniversalWebViewController.h"
#import "WKHandleBridgeEventManager.h"

@interface WKUniversalWebViewController ()<WKScriptMessageHandler>

@property (nonatomic, copy) NSMutableDictionary * methodBridgeBlockDictionary;//方法名对应的完成处理block的字典

@property (nonatomic, strong) WKHandleBridgeEventManager * handleBridgeEventManager;//用以处理web中自处理事件
@end

@implementation WKUniversalWebViewController

#pragma mark - cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 自定义方法

//初始化
- (void)initWebView
{
    [self registerOCBridgeJSMethodName:@"setAppWebTitle" scriptMessageHandle:self];

    [self addJSBridgeOCMethodName:@"getAppShareFunction" completionHandle:nil];
    [self addJSBridgeOCMethodName:@"getAppLogOut" completionHandle:nil];
    [self addJSBridgeOCMethodName:@"getAppToken" completionHandle:nil];
    [self addJSBridgeOCMethodName:@"getAppVersion" completionHandle:nil];
}

//添加代理桥接方法
- (void)addJSBridgeOCMethodName:(NSString *)methodName completionHandle:(CompletionBlock)completion
{
    if ([NSObject isValidateInitString:methodName]) {
    
        if (completion) {
            
            [self.methodBridgeBlockDictionary setObject:completion forKey:methodName];
        }
        
        [self registerOCBridgeJSMethodName:methodName scriptMessageHandle:self];
    }
}

//设置分享按钮
- (void)setSharedOpertionWithParams:(NSDictionary *)params
{
    [self.handleBridgeEventManager setNativeSharedDictionary:params];
}

//设置产品id用于分享
- (void)setSharedProductId:(NSString *)productId
{
    [self.handleBridgeEventManager setProductId:productId];
}

#pragma mark - 回调处理

//注册的方法对应的回调
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSString * methodName = message.name;
    
    if ([methodName isEqualToString:@"setAppWebTitle"]) {
        
        self.title = [message.body objectForKey:@"title"];
        return;
    }
    
    CompletionBlock completion = [self.methodBridgeBlockDictionary objectForKey:methodName];
    if ([NSObject isValidateObj:completion]) {
        
        completion(message.body);
    }else
    {
        [self.handleBridgeEventManager performSelector:NSSelectorFromString(methodName) withObject:message.body
                                            afterDelay:0.0f];
    }
}

#pragma mark - settter/getter
- (NSMutableDictionary *)methodBridgeBlockDictionary
{
    if (!_methodBridgeBlockDictionary) {
        
        _methodBridgeBlockDictionary= [[NSMutableDictionary alloc]init];
    }
    return _methodBridgeBlockDictionary;
}

- (WKHandleBridgeEventManager *)handleBridgeEventManager
{
    if (!_handleBridgeEventManager) {
        
        _handleBridgeEventManager = [[WKHandleBridgeEventManager alloc]init];
        _handleBridgeEventManager.mainWebViewController = self;
    }
    return _handleBridgeEventManager;
}
@end
