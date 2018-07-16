//
//  AssistLayer.m
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "AssistLayer.h"

@interface AssistLayer ()
{
    CommonReachability * _reachability;
}
- (void) handleNetworkChange:(NSNotification *)notice;
@end

@implementation AssistLayer

- (id)init
{
    if (self = [super init]) {
        
        // 注册消息，消息名称kReachabilityChangedNotification，该消息的响应函数为handleNetworkChange:
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
        
        //返回当前连接到的网路对象
        _reachability = [CommonReachability reachabilityForInternetConnection];
        
        //开始监听网络变化消息
        [_reachability startNotifier];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
}

// 网络状态变化的通知
- (void) handleNetworkChange:(NSNotification *)notice{
    // 收到网络变化通知后，立即查询当前网络状态
    networkStatus status = [_reachability currentReachabilityStatus];
    
    // 状态去重
    static int lastStatus = -1;
    if (lastStatus == status) {
        return ;
    }
    lastStatus = status;
    
    NSString *descriptionDetail = @"";
    switch (status) {
        case Network_NotReachable:// 无连接
            descriptionDetail = [[NSString alloc]initWithUTF8String: NETWORKSTATUS_NOTREACHABLE];
            break;
        case Network_ReachableViaWiFi: // 已连接到Wifi网络
            descriptionDetail = [[NSString alloc]initWithUTF8String: NETWORKSTATUS_WIFI];
            break;
        case Network_ReachableViaWWAN: // 已连接到WWAN网络
            descriptionDetail = [[NSString alloc]initWithUTF8String: NETWORKSTATUS_WWAN];
            break;
            
        default:
            break;
    }
    // 通知UI和逻辑层的网络变化
    [[NSNotificationCenter defaultCenter] postNotificationName: UINetworkChangedNotification object:descriptionDetail];
}

// 查询当前网络状态
- (NSInteger)getNetworkStatus
{
    networkStatus status = [_reachability currentReachabilityStatus];
    NSInteger nNetworkStatus = status;
    return nNetworkStatus;
}

@end
