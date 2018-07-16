//
//  XNDeviceUtil.m
//  MoneyJar2
//
//  Created by XNKJ on 6/3/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XNDeviceUtil.h"

@implementation XNDeviceUtil

+ (XNDeviceScreenType)currentDeviceScreenType {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat screenMaxSide = MAX(screenSize.width, screenSize.height);
    if (screenMaxSide <= 480) {
        
        return XNDeviceScreenType_3_5;
    } else if (screenMaxSide <= 568) {
        
        return XNDeviceScreenType_4_0;
    } else if (screenMaxSide <= 667) {
        
        return XNDeviceScreenType_4_7;
    } else if (screenMaxSide <= 736) {
        
        return XNDeviceScreenType_5_5;
    } else if (screenMaxSide <= 1024) {
        
        return XNDeviceScreenType_iPad;
    } else {
        
        return XNDeviceScreenType_Unknown;
    }
}

+ (CGFloat)screenLongerSideLength {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return MAX(screenSize.width, screenSize.height);
}

+ (CGFloat)screenShorterSideLength {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return MIN(screenSize.width, screenSize.height);
}

+ (CGFloat)screenWidth {
    
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight {
    
    return [UIScreen mainScreen].bounds.size.height;
}

+ (BOOL)systemIsIos8AndLater {
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    return [systemVersion floatValue] >= 8.f;
}

+ (NSString *)currentAppVersion {
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
