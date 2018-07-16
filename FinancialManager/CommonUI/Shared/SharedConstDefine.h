//
//  SharedConstDefine.h
//  FinancialManager
//
//  Created by xnkj on 15/9/25.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#ifndef SHAREDCONSTDEFINE
#define SHAREDCONSTDEFINE

typedef NS_ENUM(NSInteger, SharedType){
    WXFriend_SharedType,
    WXFriendArea_SharedType,
    Copy_SharedType
};

typedef NS_ENUM(NSInteger, WXSceneType){
    
    Session_WXSceneType, //朋友
    TimeLine_WXSceneType //朋友圈
};

#define XN_WEIBO_PUBLIC_DEFAULT_TITLE @"来自领会科技"
#define XN_WEIBO_PUBLIC_DEFAULT_ICON  @""

#define XN_WEIBO_PUBLIC_CONTENT @"XN_WEIBO_PUBLIC_CONTENT"
#define XN_WEIBO_PUBLIC_URL     @"XN_WEIBO_PUBLIC_URL"
#define XN_WEIBO_PUBLIC_ICON    @"XN_WEIBO_PUBLIC_ICON"
#define XN_WEIBO_PUBLIC_TITLE   @"XN_WEIBO_PUBLIC_TITLE"

#define XN_COPY_CONTENT         @"XN_COPY_CONTENT"

#define WXAPPLICATIONHANDLEOPENURLNOTIFICATION @"WXApplicationHandleOpenURLNotification"
#define WXAPPLICATIONOPENURLNOTIFICATION       @"WXApplicationOpenURLNotification"
#endif