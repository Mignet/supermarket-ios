
//
//  GXQGlobalConfig.m
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "AppFrameworkConfig.h"
#import "AFSecurityPolicy.h"

#define APP_ENVIRONMENT_ITEM                             APP_TEST_ENVIRONMENT

@interface AppFrameworkConfig()

@property (nonatomic, copy) completeBlock completeBlock;
@end

@implementation AppFrameworkConfig

- (id)init
{
    self = [super init];
    if (self) {
        // 初始化一些默认值
        _vc.fBarShadowHeight = 4.0f;
        _vc.fXLActivityIndicatorViewFontSize = 13.0f;
        _vc.fXLTableCellDefHeight = 44;
        
        [self loadEnvironmentOption];
    }
    return self;
}

//环境默认切换
- (void)loadEnvironmentOption
{
    if (APP_ENVIRONMENT_ITEM == APP_DEVELOPER_ENVIRONMENT) {
        
        //测试环境
        self.XN_REQUEST_HTTP_BASE_URL = @"http://10.16.0.204:8080/mockjs/8";
        self.XN_REQUEST_HTTPS_BASE_URL = @"http://10.16.0.204:8080/mockjs/8";
        
        //h5环境
        //测试环境
        self.XN_REQUEST_H5_BASE_URL= @"http://10.16.0.205:6810";
        self.WECHAT_XN_REQUEST_H5_BASE_URL = @"http://10.16.0.205:6810";
        
        //环信移动客服账号名
        self.XN_SERVICE_EASEMOB_NAME = @"tophlctest";
        
        //环信
        self.XNHXAPPKEY = @"linghuilicai#lhlcs";
        self.XNHXCERNAME = @"lcds_apns_developer";
        
        //友盟key
        self.UMKEY = @"59b63e53ae1bf82dd7000d97";
        
        //// 个推
        self.GETUI_APPID = @"HQLGzH3xfp7ludDWdv01e2";
        self.GETUI_APPKEY = @"6EYEqFfTgI9gR3uDhADknA";
        self.GETUI_APPSECRET = @"5K7cLqYuHw7TZK87MM6it1";
        
        //测试
        self.PROFIT_DISTRIBUTION_EXPLAIN_URL = @"https://preliecai.toobei.com/pages/question/balance_rule.html";
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"当前使用的猎财大师为V%@开发版",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [alertView show];
    }else if(APP_ENVIRONMENT_ITEM == APP_TEST_ENVIRONMENT)
    {
        //测试环境
        self.XN_REQUEST_HTTP_BASE_URL = @"http://premarket.toobei.com/rest/api";
        self.XN_REQUEST_HTTPS_BASE_URL = @"https://premarket.toobei.com/rest/api";
        
        //h5环境
        //测试环境
        self.XN_REQUEST_H5_BASE_URL= @"https://preliecai.toobei.com";
        self.WECHAT_XN_REQUEST_H5_BASE_URL = @"https://prenliecai.toobei.com";
        
        //环信移动客服账号名
        self.XN_SERVICE_EASEMOB_NAME = @"tophlctest";
        
        //环信
        self.XNHXAPPKEY = @"linghuilicai#lhlcs";
        self.XNHXCERNAME = @"lcds_apns_developer";
        
        //友盟key
        self.UMKEY = @"59b63e53ae1bf82dd7000d97";
        
        //// 个推
        self.GETUI_APPID = @"HQLGzH3xfp7ludDWdv01e2";
        self.GETUI_APPKEY = @"6EYEqFfTgI9gR3uDhADknA";
        self.GETUI_APPSECRET = @"5K7cLqYuHw7TZK87MM6it1";
        
        //测试
        self.PROFIT_DISTRIBUTION_EXPLAIN_URL = @"https://preliecai.toobei.com/pages/question/balance_rule.html";
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"当前使用的猎财大师为V%@测试版",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [alertView show];
    }else
    {
        //线上环境
        self.XN_REQUEST_HTTP_BASE_URL = @"http://market.toobei.com/rest/api";
        self.XN_REQUEST_HTTPS_BASE_URL = @"https://market.toobei.com/rest/api";
        
        //h5环境
        //线上环境
        self.XN_REQUEST_H5_BASE_URL= @"https://liecai.toobei.com";
        self.WECHAT_XN_REQUEST_H5_BASE_URL = @"https://nliecai.toobei.com";
        
        //环信移动客服账号名
        self.XN_SERVICE_EASEMOB_NAME = @"toobeiCustomerServiceImAccount";
        
        //环信
        self.XNHXAPPKEY = @"linghuilicai#toobei";  //正式环境
        self.XNHXCERNAME = @"lcds_apns_product";
        
        //友盟key
        self.UMKEY = @"59b63e8275ca3529b40012ad";
        
        //// 线上
        self.GETUI_APPID = @"QylcbqtCdhAVhRbKu9AHT2";
        self.GETUI_APPKEY = @"lMh6JwxKzq5u5QKxl6Dvn3";
        self.GETUI_APPSECRET = @"BLy0lqm8Cc7zGM0Hheqj13";
        
        //线上
        self.PROFIT_DISTRIBUTION_EXPLAIN_URL = @"https://liecai.toobei.com/pages/question/balance_rule.html";
    }
    
    self.webServiceBaseUrl = self.XN_REQUEST_HTTP_BASE_URL;
    self.passportBaseUrl = self.XN_REQUEST_HTTPS_BASE_URL;
}

//环境切换
//加载环境切换
- (void)loadSwitchEnvironmentOptionComplete:(completeBlock)complete
{
    if (complete) {
        
        self.completeBlock = nil;
        self.completeBlock = [complete copy];
    }
    
#ifdef DEBUG
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"环境切换" message:@"" delegate:self cancelButtonTitle:@"预发布环境" otherButtonTitles:@"线上环境", nil];
    
    [alertView show];
    
    return;
#else
    
    //线上环境
    self.XN_REQUEST_HTTP_BASE_URL = @"http://market.toobei.com/rest/api";
    self.XN_REQUEST_HTTPS_BASE_URL = @"https://market.toobei.com/rest/api";
    
    //h5环境
    //线上环境
    self.XN_REQUEST_H5_BASE_URL= @"https://liecai.toobei.com";
     self.WECHAT_XN_REQUEST_H5_BASE_URL = @"https://nliecai.toobei.com";
    
    //环信移动客服账号名
    self.XN_SERVICE_EASEMOB_NAME = @"toobeiCustomerServiceImAccount";
    
    //环信
    self.XNHXAPPKEY = @"linghuilicai#toobei";  //正式环境
    self.XNHXCERNAME = @"lcds_apns_product";
    
    //友盟key
    self.UMKEY = @"59b63e8275ca3529b40012ad";
    
    //// 线上
    self.GETUI_APPID = @"QylcbqtCdhAVhRbKu9AHT2";
    self.GETUI_APPKEY = @"lMh6JwxKzq5u5QKxl6Dvn3";
    self.GETUI_APPSECRET = @"BLy0lqm8Cc7zGM0Hheqj13";
    
    //线上
    self.PROFIT_DISTRIBUTION_EXPLAIN_URL = @"https://liecai.toobei.com/pages/question/balance_rule.html";
    
    
    self.webServiceBaseUrl = self.XN_REQUEST_HTTP_BASE_URL;
    self.passportBaseUrl = self.XN_REQUEST_HTTPS_BASE_URL;
    
    if (self.completeBlock)
        self.completeBlock();
#endif
}

#pragma mark - delegate

//UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
       if (APP_ENVIRONMENT_ITEM == APP_DEVELOPER_ENVIRONMENT) {
        
            //测试环境
            self.XN_REQUEST_HTTP_BASE_URL = @"http://10.16.0.205:6810/rest/api";
            self.XN_REQUEST_HTTPS_BASE_URL = @"http://10.16.0.205:6810/rest/api";
            
            //h5环境
            self.XN_REQUEST_H5_BASE_URL= @"http://10.16.0.205:6810";
            self.WECHAT_XN_REQUEST_H5_BASE_URL = @"http://10.16.0.205:6810";
           
       }else if(APP_ENVIRONMENT_ITEM == APP_TEST_ENVIRONMENT)
       {
          
           //测试环境
           self.XN_REQUEST_HTTP_BASE_URL = @"http://premarket.toobei.com/rest/api";
           self.XN_REQUEST_HTTPS_BASE_URL = @"https://premarket.toobei.com/rest/api";
           
           self.XN_REQUEST_H5_BASE_URL= @"https://preliecai.toobei.com";
           self.WECHAT_XN_REQUEST_H5_BASE_URL = @"https://prenliecai.toobei.com";
       }
        
        //环信移动客服账号名
        self.XN_SERVICE_EASEMOB_NAME = @"tophlctest";
        
        //环信
        self.XNHXAPPKEY = @"linghuilicai#lhlcs";  //正式环境
        self.XNHXCERNAME = @"lcds_apns_developer";
        
        //友盟key
        self.UMKEY = @"58a3cd8d677baa2883000261";
        
        //// 线上
        self.GETUI_APPID = @"HQLGzH3xfp7ludDWdv01e2";
        self.GETUI_APPKEY = @"6EYEqFfTgI9gR3uDhADknA";
        self.GETUI_APPSECRET = @"5K7cLqYuHw7TZK87MM6it1";
        
        //线上
        self.PROFIT_DISTRIBUTION_EXPLAIN_URL = @"https://preliecai.toobei.com/pages/question/balance_rule.html";
    }else
    {
        //线上环境
        self.XN_REQUEST_HTTP_BASE_URL = @"http://market.toobei.com/rest/api";
        self.XN_REQUEST_HTTPS_BASE_URL = @"https://market.toobei.com/rest/api";
        
        //h5环境
        //线上环境
        self.XN_REQUEST_H5_BASE_URL= @"https://liecai.toobei.com";
        self.WECHAT_XN_REQUEST_H5_BASE_URL = @"https://nliecai.toobei.com";
        
        //环信移动客服账号名
        self.XN_SERVICE_EASEMOB_NAME = @"toobeiCustomerServiceImAccount";
        
        //环信
        self.XNHXAPPKEY = @"linghuilicai#toobei";  //正式环境
        self.XNHXCERNAME = @"lcds_apns_product";
        
        //友盟key
        self.UMKEY = @"59b63e8275ca3529b40012ad";
        
        //// 线上
        self.GETUI_APPID = @"QylcbqtCdhAVhRbKu9AHT2";
        self.GETUI_APPKEY = @"lMh6JwxKzq5u5QKxl6Dvn3";
        self.GETUI_APPSECRET = @"BLy0lqm8Cc7zGM0Hheqj13";
        
        //线上
        self.PROFIT_DISTRIBUTION_EXPLAIN_URL = @"https://liecai.toobei.com/pages/question/balance_rule.html";
    }
    
    self.webServiceBaseUrl = self.XN_REQUEST_HTTP_BASE_URL;
    self.passportBaseUrl = self.XN_REQUEST_HTTPS_BASE_URL;
    
    if (self.completeBlock)
        self.completeBlock();
}

@end
