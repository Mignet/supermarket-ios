//
//  GeTuiManager.h
//  FinancialManager
//
//  Created by xnkj on 2016/8/19.
//  Copyright © 2016年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeTuiManager : NSObject

/**
 * 获取个推管理对象
 **/
+ (instancetype)sharedGeTuiInstance;

/**
 * 启动个推
 *
 * params appId  个推网站注册的appid
 * params appKey  个推网站注册的appkey
 * params appSecret 个推网站注册的appsecret
 **/
- (void)initGeTuiAppId:(NSString *)appId
                appKey:(NSString *)appKey
             appSecret:(NSString *)appSecret;

/**
 * 注册设备id
 *
 * params token 设备token
 *
 **/
- (void)registerDeviceToken:(NSString *)token;

/**
 * 后台恢复个推数据处理
 **/
- (void)resume;

/**
 * 设置启动状态
 *
 * params launchStatus 热启动／冷启动
 **/
- (void)setLaunchStatus:(BOOL)launchStatu;


/*
 * 同步角标到服务器
 *
 * params badgeCount 角标数目
 *
 **/
- (void)setBadge:(NSInteger)badgeCount;

/**
 * 重置角标
 **/
- (void)resetBadge;

/**
 * 设置apns通知的点击数目,用于统计有效通知点击次数
 *
 * params userinfo 通知字典
 *
 **/
- (void)handleRemoteNotification:(NSDictionary *)userInfo;
@end
