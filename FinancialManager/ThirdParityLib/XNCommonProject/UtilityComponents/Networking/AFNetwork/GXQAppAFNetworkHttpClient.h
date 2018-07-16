//
//  GXQAppAFNetworkHttpsClient.h
//  GXQApp
//
//  Created by 振增 黄 on 14-11-27.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "GXQAppAFNetworkClientDelegate.h"

@interface GXQAppAFNetworkHttpClient : NSObject<GXQAppAFNetworkClientDelegate>

+ (instancetype)sharedClient;

@end
