//
//  Common.h
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#ifndef GXQApp_Common_h
#define GXQApp_Common_h


// 全局宏定义,约定不能直接使用_CORE
#define _CORE   ((AppDelegate*)[UIApplication sharedApplication].delegate)
#define _UI     _CORE.objUILayer
#define _LOGIC  _CORE.objLogicLayer
#define _ASSIST  _CORE.objAssistLayer
#define _KEYWINDOW  ([[UIApplication sharedApplication] keyWindow])
#define _KEY_WINDOW ([[UIApplication sharedApplication] keyWindow])
#define _SKIN _CORE.objSkinManager

//常用颜色定义
#define  JFZ_COLOR_GRAY UIColorFromHex(0x6c6e6d)
#define  JFZ_COLOR_LIGHT_GRAY       UIColorFromHex(0x4f5960)
#define  JFZ_COLOR_BLUE             UIColorFromHex(0x4e8cef)
#define  JFZ_COLOR_ORANGE           UIColorFromHex(0xff8400)
#define  JFZ_COLOR_BLACK UIColorFromHex(0x3e4446)
#define  JFZ_LINE_COLOR_GRAY UIColorFromHex(0xefefef)
#define  JFZ_COLOR_PAGE_BACKGROUND UIColorFromHex(0xeeeff3)

#define  JFZ_COLOR_NORMAL_BLACK     RGBA(56.0 ,56.0 ,56.0 ,1.0)


// 屏幕的frame
#define SCREEN_FRAME       [[UIScreen mainScreen] bounds]
#define SCREEN_CENTER [[UIScreen mainScreen] center]

#define IS_WIDTH_SCREEN() (([UIScreen mainScreen].bounds.size.height == 480) == NO)
#define IS_SHOTIPHONE_SCREEN() (([UIScreen mainScreen].bounds.size.height <= 568) == YES)
#define Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

static inline CGFloat getNavigationHeight(UIView *view){
    
    if (@available(iOS 11.0, *)) {
        return view.safeAreaInsets.top;
    }
    
    return 64.0;
}


static inline UIEdgeInsets safeAreaInsets(UIView *view) {
    if (@available(iOS 11.0, *)) {
        return view.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}


// 版本兼容控制
#define DETY ([UIDevice currentDevice].systemVersion.floatValue>=7.0?20:0)
#define IOS7_OR_LATER   ([UIDevice currentDevice].systemVersion.floatValue>=7.0?YES:NO)
#define IOS6_OR_LATER   ([UIDevice currentDevice].systemVersion.floatValue>=6.0?YES:NO)
#define IOS5_OR_LATER   ([UIDevice currentDevice].systemVersion.floatValue>=5.0?YES:NO)
#define IOS7_EARLIER    ([UIDevice currentDevice].systemVersion.floatValue<7.0?YES:NO)
#define IOS8_EARLINE    ([UIDevice currentDevice].systemVersion.floatValue<8.0?YES:NO)
#define IOS8_OR_LATER   ([UIDevice currentDevice].systemVersion.floatValue>=8.0?YES:NO)
#define IOS9_OR_LATER   ([UIDevice currentDevice].systemVersion.floatValue>=9.0?YES:NO)
#define IOS10_OR_LATER   ([UIDevice currentDevice].systemVersion.floatValue>=10.0?YES:NO)
#define IS_IPHONE6PLUS_SCREEN (([UIScreen mainScreen].bounds.size.height == 736) == YES)
#define IOS_IPHONE5OR4_SCREEN (([UIScreen mainScreen].bounds.size.width == 320) == YES)
#define IOS_IPHONE4_SCREEN (([UIScreen mainScreen].bounds.size.height == 480) == YES)

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v optiona:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] compare:v options:NSNumericSearch] != NSOrderedDescending)

// 对话框自动消失时间
#define ALERT_DISSMISS_TIME (1.2f)
#define NEW_VERSION_HINT_DISMISS_TIME           (3.0f)

#define ALERT_REQUEST_FAILED  @"网络不给力，请检查您的网络" 
#define ALERT_NO_NETWORK   @"网络异常，拉取数据失败"

#define JFZ_APP_URL @"http://xn66"

#define degreesToRadians(x) (M_PI*(x)/180.0)

#define PHONE_VIEW_SOURCE_CONTROLLER        @"PHONE_VIEW_SOURCE_CONTROLLER"

#define weakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

typedef NS_ENUM(NSInteger, PhoneViewSourceController) {
    isFromInvalid = 0,
    isFromDefault = 1,
    isFromForgetPassword = 2,
    isFromRegister = 3,
    isFromResetPassword = 4,
    isFromWebView = 5,
    isFromMySchemeRoot = 6,
    isFromMyFinancialDetail = 7,
    isFromGesturePassWordView = 8,
    isFromExtendMoneyController = 9,
    isFromEarnMoneyController = 10,
    isFromMyFundsController = 11,
    isFromMsgCenter = 12,
    isFromAccountCenterNote = 13,
    isFromMax = 14

    
};

typedef NS_ENUM(NSInteger, DefaultTabBarIndex)
{
    homeTabBarIndex = 0,
    equityFundTabBarIndex = 1,
    noteTabBarIndex = 2,
    accountCenterTabBarIndex = 3
};

#endif
