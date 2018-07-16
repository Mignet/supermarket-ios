//
//  UIDevice+XL.h
//  XL
//
//  Created by czh0766 on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    IPOD, IPOD2, IPOD3, IPOD4,
    IPHONE, IPHONE_3G, IPHONE_3GS, IPHONE4, IPHONE_4S,IPHONE_5,IPHONE_5C,
    IPAD, IPAD2, NEW_IPAD,
    IOS_SIMULATOR, DEVICE_UNKNOWN
};


enum {
    // iPhone 1,3,3GS 标准分辨率(320x480px)
    UIDevice_iPhoneStandardRes      = 1,
    // iPhone 4,4S 高清分辨率(640x960px)
    UIDevice_iPhoneHiRes            = 2,
    // iPhone 5 高清分辨率(640x1136px)
    UIDevice_iPhoneTallerHiRes      = 3,
    // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPadStandardRes        = 4,
    // iPad 3 High Resolution(2048x1536px)
    UIDevice_iPadHiRes              = 5
}; typedef NSUInteger UIDeviceResolution;

@interface UIDevice (Common)

+(int)deviceModel;
+(NSString *)deviceDescript;

+ (UIDeviceResolution) currentResolution;

+ (NSString *)currentIPAdress;

@end
