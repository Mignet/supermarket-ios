//
//  JFZAppConstant.h
//  JinFuZiApp
//
//  Created by ganquan on 4/10/15.
//  Copyright (c) 2015 com.jinfuzi. All rights reserved.
//

#ifndef AppConstant_h
#define AppConstant_h

//环境切换，0表示线上发布，1表示预发布环境，测试环境

//#define APP_TEST_ENVIRONMENT                       (0)             //预发布环境
//#define APP_ONLINE_ENVIRONMENT                        (1)             //线上环境
//
//#define APP_ENVIRONMENT_ITEM                             APP_TEST_ENVIRONMENT

//#if (APP_ENVIRONMENT_ITEM == APP_TEST_ENVIRONMENT)
//
//    #if 0
//      //开发环境
//        #define XN_REQUEST_HTTP_BASE_URL @"http://testmarket.toobei.com/rest/api"
//        #define XN_REQUEST_HTTPS_BASE_URL @"https://testmarket.toobei.com/rest/api"
//    #else
//
//       //预发布
//        #define XN_REQUEST_HTTP_BASE_URL   @"http://premarket.toobei.com/rest/api"
//        #define XN_REQUEST_HTTPS_BASE_URL @"https://premarket.toobei.com/rest/api"
//    #endif
//
//    //h5环境
//    //预发布环境
//    #define XN_REQUEST_H5_BASE_URL @"https://preliecai.toobei.com"
//
//    //环信移动客服账号名
//    #define XN_SERVICE_EASEMOB_NAME @"tophlctest"
//
//    //环信数据
//    #define XNHXAPPKEY @"linghuilicai#lhlcs"  //测试环境
//    #define XNHXCERNAME @"lcds_apns_developer"
//
//    //友盟key
//    #define UMKEY @"58a3cd8d677baa2883000261"
//
//    //测试环境
//    #define GETUI_APPID @"HQLGzH3xfp7ludDWdv01e2"
//    #define GETUI_APPKEY @"HQLGzH3xfp7ludDWdv01e2"
//    #define GETUI_APPSECRET @"5K7cLqYuHw7TZK87MM6it1"
//
//    //测试环境
//    #define PROFIT_DISTRIBUTION_EXPLAIN_URL @"https://preliecai.toobei.com/pages/question/balance_rule.html"
//
//#else
//
//    //线上环境
//    #define XN_REQUEST_HTTP_BASE_URL    @"http://market.toobei.com/rest/api"
//    #define XN_REQUEST_HTTPS_BASE_URL @"https://market.toobei.com/rest/api"
//
//    //h5环境
//    //线上环境
//    #define XN_REQUEST_H5_BASE_URL @"https://liecai.toobei.com"
//
//   //环信移动客服账号名
//    #define XN_SERVICE_EASEMOB_NAME @"toobeiCustomerServiceImAccount"
//
//    //环信
//    #define XNHXAPPKEY @"linghuilicai#toobei"  //正式环境
//    #define XNHXCERNAME @"lcds_apns_product"
//
//    //友盟key
//    #define UMKEY @"57b53117e0f55a5ccf0010ae"
//
//    //// 线上
//    #define GETUI_APPID @"QylcbqtCdhAVhRbKu9AHT2"
//    #define GETUI_APPKEY @"lMh6JwxKzq5u5QKxl6Dvn3"
//    #define GETUI_APPSECRET @"BLy0lqm8Cc7zGM0Hheqj13"
//
//    //线上
//    #define PROFIT_DISTRIBUTION_EXPLAIN_URL @"https://liecai.toobei.com/pages/question/balance_rule.html"
//#endif

//公共部分
#define XN_SERVICE_WORK_TIME @"客服时间：工作日09:00-18:00"
#define XN_SERVICE_INTERFACE_VERSION @"1.0.0"
#define XN_RUNTIME_KEY               @"xiaoniu66"
#define XN_RUNTIME_WARNING_BLOCK_KEY @"warning_block_xiaoniu66"
#define XN_RUNTIME_OK_BLOCK_KEY      @"ok_block_xiaoniu66"
#define XN_RUNTIME_CANCEL_BLOCK_KEY  @"cancel_block_xiaoniu66"
#define XN_RUNTIME_ANNOUNCE_PROPERTY_KEY @"announce_property_xiaoniu66"
#define XN_RUNTIME_MYMESSAGE_PROPERTY_KEY @"mymessage_property_xiaoniu66"
#define XN_LOGIN_SOURCE_KEY          @"XN_LOGIN_SOURCE_KEY"
#define XN_LIBRARY_COMMON_DIRECTORY  @"COMMON"

#define HTTP_REQUEST_TIMEOUT (15.0f)

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBCOLOR(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define REQUESTSIGNAPPSECURATE @"F1D007ECF30A4E9EBEC2E0277C60C637"
#define WEBVIEWREQUESTTIMEOUT 15.0f
#define VIEWANIMATIONDURATION 0.3f
#define CUSTOMALERTVIEWSHOW   1.0f
#define GXQ_HTTPS_CER_PASSWORD @"gxq2014"
#define GXQ_HTTPS_CER_NAME     @"gxqcom"

#define PHONEVIEW_CONFIRM_BACKGROUND UIColorFromHex(0xEF4A3B)
#define UINavigationItemMessageCountTextColor UIColorFromHex(0xFFFFFF)
#define MONEYCOLOR UIColorFromHex(0x4e8cef)

#define DEPORTMONEYCOLOR UIColorFromHex(0x4e8cef)
#define DEPORTMONEYFEECOLOR UIColorFromHex(0xa2a2a2)

#endif
