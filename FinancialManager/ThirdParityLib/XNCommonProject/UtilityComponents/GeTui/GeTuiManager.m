//
//  GeTuiManager.m
//  FinancialManager
//
//  Created by xnkj on 2016/8/19.
//  Copyright © 2016年 xiaoniu. All rights reserved.
//

#import "GeTuiManager.h"
#import <UserNotifications/UserNotifications.h>

#import "GeTuiSdk.h"
#import "AppConstant.h"

#import "AppDelegate.h"
#import "MyCustomerDetailViewController.h"
#import "MIMonthIncomeViewController.h"
#import "MIDeportDetailController.h"
#import "MIMessageContainerController.h"
#import "MyCfgDetailViewController.h"
#import "UniversalInteractWebViewController.h"

#import "CalendarManager.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

@interface GeTuiManager()<GeTuiSdkDelegate>

@property (nonatomic, assign) BOOL coldLaunch;
@end

@implementation GeTuiManager

#pragma mark - 生命周期-start

/**
 * 获取个推管理对象
 **/
+ (instancetype)sharedGeTuiInstance
{
    static GeTuiManager * manager = nil;
    static dispatch_once_t once ;
    dispatch_once(&once, ^{
       
        manager = [[GeTuiManager alloc]init];
    });
    
    return manager;
}

/**
 * 启动个推
 *
 * params appId  个推网站注册的appid
 * params appKey  个推网站注册的appkey
 * params appSecret 个推网站注册的appsecret
 **/
- (void)initGeTuiAppId:(NSString *)appId
                appKey:(NSString *)appKey
             appSecret:(NSString *)appSecret
{
    [GeTuiSdk startSdkWithAppId:appId
                         appKey:appKey
                      appSecret:appSecret
                       delegate:self];
    
    self.coldLaunch = YES;
}

#pragma mark - end

#pragma mark - 业务逻辑

/**
 * 注册设备id
 *
 * params token 设备token
 *
 **/
- (void)registerDeviceToken:(NSString *)token
{
    [GeTuiSdk registerDeviceToken:token];
}

/**
 * 后台恢复个推数据处理
 **/
- (void)resume
{
    [GeTuiSdk resume];
}

/**
 * 设置启动状态
 *
 * params launchStatus 热启动／冷启动
 **/
- (void)setLaunchStatus:(BOOL)launchStatu
{
    self.coldLaunch = launchStatu;
}

/*
 * 同步角标到服务器
 *
 * params badgeCount 角标数目
 *
 **/
- (void)setBadge:(NSInteger)badgeCount
{
    [GeTuiSdk setBadge:badgeCount];
}

/**
 * 重置角标
 **/
- (void)resetBadge
{
    [GeTuiSdk resetBadge];
}

/**
 * 设置apns通知的点击数目,用于统计有效通知点击次数
 *
 * params userinfo 通知字典
 *
 **/
- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    [GeTuiSdk handleRemoteNotification:userInfo];
}

#pragma mark - Protocol

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    
    //登录注册的时候将clientid传递给后台
    [_LOGIC saveValueForKey:XN_DEVICE_TOKEN_TAG Value:clientId];
}

/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    
    //如果app在前台，则不做任何处理
    if (self.coldLaunch && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge > 0)
        {
            //清除标记，清除小红圈中数字
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        [self setBadge:0];
        
        return;
    }
    
    // [4]: 收到个推消息
    NSString *payloadMsg = nil;
    NSDictionary * userInfo = nil;
    NSError * error = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
        
        userInfo = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingMutableContainers error:&error];
        
        NSString *valueString = [userInfo objectForKey:@"customUrlKey"];
        
        if ([valueString isEqualToString:@"lcsSysNoticeRelease"])
        {
            //公告详情链接
            if ([userInfo objectForKey:@"msgUrl"])
            {
                UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc] initRequestUrl:[userInfo objectForKey:@"msgUrl"] requestMethod:@"GET"];
                [interactWebViewController setNeedNewSwitchViewAnimation:YES];
                
                NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
                if (![NSObject isValidateInitString:token]) {
                    
                    [interactWebViewController setSwitchToHomePage:NO];
                }
                
                
                [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
            }
            else
            {
                return;
            }
            
        }
        else if ([valueString isEqualToString:@"lcsSysActivityRelease"])
        {
            //活动详情链接
            if ([userInfo objectForKey:@"activityUrl"])
            {
                UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc] initRequestUrl:[userInfo objectForKey:@"activityUrl"] requestMethod:@"GET"];
                [interactWebViewController setNeedNewSwitchViewAnimation:YES];
                
                NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
                if (![NSObject isValidateInitString:token]) {
                    
                    [interactWebViewController setSwitchToHomePage:NO];
                }
                
                [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
            }
            else
            {
                return;
            }
        }
        
        if ([userInfo objectForKey:@"customUrlKey"] == nil)
        {
            //发送通知，改变导航栏图标
            [[NSNotificationCenter defaultCenter] postNotificationName:XN_UNREAD_SERVICE_MSG object:@"1"];
            return;
        }
    
        if ([valueString isEqual:@"cusDetail"])
        {
            //客户id
            if ([userInfo objectForKey:@"customerId"])
            {
                MyCustomerDetailViewController *viewController = [[MyCustomerDetailViewController alloc] initWithNibName:@"CSCustomerDetailController" bundle:nil userId:[userInfo objectForKey:@"customerId"]];
                [viewController setNeedNewSwitchViewAnimation:YES];
                
                NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
                if (![NSObject isValidateInitString:token]) {
                    
                    [viewController setSwitchToHomePage:NO];
                }
                
                [_UI pushViewControllerFromRoot:viewController animated:YES];
            }
            else
            {
                return;
            }
        }
        else if ([valueString isEqual:@"teamDetail"])
        {
            //用户编码
            if ([userInfo objectForKey:@"userNumber"])
            {
                MyCfgDetailViewController *viewController = [[MyCfgDetailViewController alloc] initWithNibName:@"MyCfgDetailViewController" bundle:nil userId:[userInfo objectForKey:@"userNumber"]];
                [viewController setNeedNewSwitchViewAnimation:YES];
                
                NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
                if (![NSObject isValidateInitString:token]) {
                    
                    [viewController setSwitchToHomePage:NO];
                }
                
                [_UI pushViewControllerFromRoot:viewController animated:YES];
            }
            else
            {
                return;
            }
        }
        else if ([valueString isEqual:@"myAccount"])
        {
            NSString * profitTypeStr = [userInfo objectForKey:@"profitType"];
            NSString * profitMonthStr = [userInfo objectForKey:@"month"];
            
            NSString * title = @"";
            if ([[[CalendarManager defaultManager] dateComponentsWithDate:[NSDate date]] month] == [[[CalendarManager defaultManager] dateComponentsWithDate:[NSString dateFromString:profitMonthStr formater:@"yyyy-MM"]] month])
            {
                title = @"本月收益";
            }else
                title = [NSString stringWithFormat:@"%@月收益",[NSNumber numberWithInteger:[[[CalendarManager defaultManager] dateComponentsWithDate:[NSString dateFromString:profitMonthStr formater:@"yyyy-MM"]] month]]];
            
            //账户详情
            MIMonthIncomeViewController * ctrl = [[MIMonthIncomeViewController alloc]initWithNibName:@"MIMonthIncomeViewController" bundle:nil title:title month:profitMonthStr profitType:profitTypeStr];
            [ctrl setNeedNewSwitchViewAnimation:YES];
            
            NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
            if (![NSObject isValidateInitString:token]) {
                
                [ctrl setSwitchToHomePage:NO];
            }
            
            [_UI pushViewControllerFromRoot:ctrl animated:YES];
        }
        else if ([valueString isEqual:@"withdraw"])
        {
            //提现记录页面
            MIDeportDetailController *viewController = [[MIDeportDetailController alloc] initWithNibName:@"MIDeportDetailController" bundle:nil];
            [viewController setNeedNewSwitchViewAnimation:YES];
            
            NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
            if (![NSObject isValidateInitString:token]) {
                
                [viewController setSwitchToHomePage:NO];
            }
            
            [_UI pushViewControllerFromRoot:viewController animated:YES];
        }
        else if ([valueString isEqual:@"notification"])
        {
            //消息通知页面
            MIMessageContainerController *viewController = [[MIMessageContainerController alloc] initWithMessageType:NotificationMessage];
            [viewController setNeedNewSwitchViewAnimation:YES];
            
            NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
            if (![NSObject isValidateInitString:token]) {
                
                [viewController setSwitchToHomePage:NO];
            }
            
            [_UI pushViewControllerFromRoot:viewController animated:YES];
        }
        else if ([valueString isEqual:@"lsjappcs"])
        {
            //职级特权
            UniversalInteractWebViewController * interactWebViewController = [[UniversalInteractWebViewController alloc]initRequestUrl:[[[XNCommonModule defaultModule] configMode] showLevelUrl] requestMethod:@"GET"];
            [interactWebViewController setNeedNewSwitchViewAnimation:YES];
            
            NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
            if (![NSObject isValidateInitString:token]) {
                
                [interactWebViewController setSwitchToHomePage:NO];
            }
            
            [_UI pushViewControllerFromRoot:interactWebViewController animated:YES];
        }
    }
    
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge > 0)
    {
        //清除标记，清除小红圈中数字
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    [self setBadge:0];
    [self setLaunchStatus:YES];
}

@end
