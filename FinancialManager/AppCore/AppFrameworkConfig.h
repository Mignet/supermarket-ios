//
//  GXQGlobalConfig.h
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct _tagSXLValueConfig{
    CGFloat fNaviDefHeight;
    CGFloat fNaviBtnDefHeight;
    CGFloat fNaviBKLeftCap;
    CGFloat fNaviBKTopCap;
    CGFloat fNaviBackBtnLeftCap;
    CGFloat fNaviBackBtnTopCap;
    CGFloat fNaviBackBtnMaxWidth;
    CGFloat fNaviBtnLeftCap;
    CGFloat fNaviBtnTopCap;
    CGFloat fNaviBtnMaxWidth;
    CGFloat fNaviImgBtnDefWidth;
    CGFloat fNaviImgBtnDefHeight;
    CGFloat fTabBarDefHeight;
    CGFloat fTabBarBKLeftCap;
    CGFloat fTabBarBKTopCap;
    CGFloat fLabelBtnHeight;
    UIEdgeInsets sLabelBtnInsets;
    UIEdgeInsets sAlertInsets;
    CGFloat fXLTableHeaderDefHeight;
    CGFloat fXLTableCellDefHeight;
    CGFloat fBarShadowHeight;
    CGFloat fXLActivityIndicatorViewFontSize;
    
} GlobalValueConfig;

typedef NS_ENUM(NSInteger, AppEnvironment) {
    env_debug = 0,                  //内网
    env_prerelease = 1,             //预发
    env_release = 2,                //线上
    env_invalid = 3                 //非法
};

typedef void(^completeBlock)();

#define APP_TEST_ENVIRONMENT                       (0)             //预发布环境
#define APP_DEVELOPER_ENVIRONMENT                  (1)             //开发环境
#define APP_ONLINE_ENVIRONMENT                     (2)             //线上环境

#define APP_OPEN_HTTPS_ENVIRONMENT                 (0)             //是否打开https 1表示打开，0表示不打开

@interface AppFrameworkConfig : NSObject

// 控件参数配置
@property (assign, nonatomic) GlobalValueConfig vc;

// GXQTabBar
@property (copy, nonatomic) NSString* imgTabBarBK;
@property (copy, nonatomic) NSString* imgTabBarBtnNormalIndex1;
@property (copy, nonatomic) NSString* imgTabBarBtnDownIndex1;
@property (copy, nonatomic) NSString* imgTabBarBtnNormalIndex2;
@property (copy, nonatomic) NSString* imgTabBarBtnDownIndex2;
@property (copy, nonatomic) NSString* imgTabBarBtnNormalIndex3;
@property (copy, nonatomic) NSString* imgTabBarBtnDownIndex3;
@property (copy, nonatomic) NSString* imgTabBarBtnNormalIndex4;
@property (copy, nonatomic) NSString* imgTabBarBtnDownIndex4;

// GXQNavigationBar
@property (copy, nonatomic) NSString* imgNaviBK;
@property (copy, nonatomic) NSString* imgNaviBackBtnNormal;
@property (copy, nonatomic) NSString* imgNaviBackBtnDown;
@property (strong, nonatomic) UIColor*  navBgColor;
@property (copy, nonatomic) UIColor*  navBgTitleColor;
@property (copy ,nonatomic) UIColor *naviItemTextColor;
@property (assign,nonatomic) UIStatusBarStyle statusBarStyle;

// app运行环境配置
@property (copy, nonatomic) NSString *passportBaseUrl;
@property (copy, nonatomic) NSString *webServiceBaseUrl;
@property (copy, nonatomic) NSString *signKey;
@property (assign, nonatomic) AppEnvironment currentEnv;
@property (copy, nonatomic) NSString *currentEvnName;

//线上环境
@property (copy, nonatomic ) NSString * XN_REQUEST_HTTP_BASE_URL;
@property (copy, nonatomic) NSString * XN_REQUEST_HTTPS_BASE_URL;

//h5环境
@property (copy, nonatomic) NSString * XN_REQUEST_H5_BASE_URL;
@property (copy, nonatomic) NSString * WECHAT_XN_REQUEST_H5_BASE_URL;

//环信移动客服账号名
@property (copy, nonatomic) NSString * XN_SERVICE_EASEMOB_NAME;

//环信
@property (copy, nonatomic) NSString * XNHXAPPKEY;
@property (copy, nonatomic) NSString * XNHXCERNAME;

//友盟key
@property (copy, nonatomic) NSString * UMKEY;

//个推
@property (copy, nonatomic) NSString * GETUI_APPID;
@property (copy, nonatomic) NSString * GETUI_APPKEY;
@property (copy, nonatomic) NSString * GETUI_APPSECRET;

//收益url
@property (copy, nonatomic) NSString * PROFIT_DISTRIBUTION_EXPLAIN_URL;

//环境默认切换
- (void)loadEnvironmentOption;

//环境切换
- (void)loadSwitchEnvironmentOptionComplete:(completeBlock)complete;

@end
