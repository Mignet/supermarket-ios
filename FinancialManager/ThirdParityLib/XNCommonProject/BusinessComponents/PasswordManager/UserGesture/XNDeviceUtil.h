//
//  XNDeviceUtil.h
//  MoneyJar2
//
//  Created by XNKJ on 6/3/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XNDeviceScreenType) {
    
    XNDeviceScreenType_Unknown,                 // 未知
    XNDeviceScreenType_3_5,                     // 3.5寸屏
    XNDeviceScreenType_4_0,                     // 4寸屏
    XNDeviceScreenType_4_7,                     // 4.7寸屏
    XNDeviceScreenType_5_5,                     // 5.5寸屏
    XNDeviceScreenType_iPad                     // ipad屏
};

@interface XNDeviceUtil : NSObject

// 当前设备屏幕尺寸类型，详见XNDeviceScreenType
+ (XNDeviceScreenType)currentDeviceScreenType;

// 屏幕长边的长度
+ (CGFloat)screenLongerSideLength;
// 屏幕短边的长度
+ (CGFloat)screenShorterSideLength;

// 屏幕宽度
+ (CGFloat)screenWidth;

// 屏幕高度
+ (CGFloat)screenHeight;

// 当前设备系统是否为8.0或更新
+ (BOOL)systemIsIos8AndLater;

// 当前app版本号
+ (NSString *)currentAppVersion;

@end
