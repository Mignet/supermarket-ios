//
//  UIDevice+XL.m
//  XL
//
//  Created by czh0766 on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIDevice+Common.h"
#include <sys/types.h>
#include <sys/sysctl.h>

//get ip adress
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation UIDevice (Common)

+(int)deviceModel {
    
    NSString *model = [self deviceDescript];

    if ([model hasPrefix:@"iPod1"]) {
        return IPOD;
    } else if ([model hasPrefix:@"iPod2"]) {
        return IPOD2;
    } else if ([model hasPrefix:@"iPod3"]) {
        return IPOD3;
    } else if ([model hasPrefix:@"iPod4"]) {
        return IPOD4;
    } else if([model isEqualToString:@"iPhone1,1"]) {
        return IPHONE;
    } else if([model isEqualToString:@"iPhone1,2"]) {
        return IPHONE_3G;
    } else if([model isEqualToString:@"iPhone2,1"]) {
        return IPHONE_3GS;
    } else if([model hasPrefix:@"iPhone3"]) {
        return IPHONE4;
    } else if([model hasPrefix:@"iPhone4"]) {
        return IPHONE_4S;
    }else if([model hasPrefix:@"iPad1"]) {
        return IPAD;
    } else if([model hasPrefix:@"iPad2"]) {
        return IPAD2;
    } else if([model hasPrefix:@"iPad3"]) {
        return NEW_IPAD;
    } else if([model isEqualToString:@"i386"]) {
        return IOS_SIMULATOR;
    } else if([model isEqualToString:@"x86_64"]) {
        return IOS_SIMULATOR;
    }
    
    return DEVICE_UNKNOWN;
}

+(NSString *)deviceDescript
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *model = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return model;
}

+ (UIDeviceResolution) currentResolution {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
            if (result.height <= 480.0f)
                return UIDevice_iPhoneStandardRes;
            return (result.height > 960 ? UIDevice_iPhoneTallerHiRes : UIDevice_iPhoneHiRes);
        } else
            return UIDevice_iPhoneStandardRes;
    } else
        return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) ? UIDevice_iPadHiRes : UIDevice_iPadStandardRes);
}

+ (NSString *)currentIPAdress
{
        NSString *address = @"error";
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0) {
            // Loop through linked list of interfaces
            temp_addr = interfaces;
            while (temp_addr != NULL) {
                if( temp_addr->ifa_addr->sa_family == AF_INET) {
                    // Check if interface is en0 which is the wifi connection on the iPhone
                    if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        // Get NSString from C String
                        address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    }
                }
                
                temp_addr = temp_addr->ifa_next;
            }
        }
        
        // Free memory
        freeifaddrs(interfaces);
        
        return address;
}
@end
