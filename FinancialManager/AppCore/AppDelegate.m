//
//  AppDelegate.m
//  FinancialManager
//
//  Created by xnkj on 15/9/17.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "AppFramework.h"
#import "AgentDetailViewController.h"
#import "UniversalInteractWebViewController.h"
#import "AgentContainerController.h"

#import "GeTuiManager.h"
#import "IMManager.h"

#ifdef DEBUG
int JCLogLevel = JC_LOG_LEVEL_INFO;
int JNLogLevel = JC_LOG_LEVEL_INFO;
#else
int JCLogLevel = JC_LOG_LEVEL_OFF;
int JNLogLevel = JC_LOG_LEVEL_OFF;
#endif

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docDir = [paths objectAtIndex:0];
    NSLog(@"path:%@",docDir);

    [UIApplication sharedApplication].statusBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (@available(iOS 11.0, *)){

        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    //启动友盟
    [XNUMengHelper startUMAnalytics];
    [self configXLFramework];
    
    [AppFramework getGlobalHandler].frontStatus = YES;
    
    [[IMManager defaultIMManager] initIManagerForApplication:application AppKey:[AppFramework getConfig].XNHXAPPKEY apnsCertName:[AppFramework getConfig].XNHXCERNAME LaunchOptions:launchOptions];
    
    //启动个推
    [self loadGTNotificationWithApplication:application];
    
    //启动lumberjack日志库
    [[LogManager sharedInstance] initLogger];
    
    // 生成各层对象
    self.objLogicLayer = [[LogicLayer alloc] init];
    self.objSkinManager = [[SkinManager alloc] init];
    self.objUILayer = [[UILayer alloc] init];
    self.objAssistLayer = [[AssistLayer alloc] init];
    
    //设置启动标志
    [_LOGIC saveValueForKey:XN_USER_ENTER_MAIN_INTERFACE Value:@"0"];
    if (![_LOGIC deviceSupportfingerPassword] || ![_LOGIC canEvaluatePolicy]) {
        
        [_LOGIC saveInt:0 key:XN_USER_FINGER_PASSWORD_SET];
    }
    
    //开始加载启动信息
    [[AppFramework getGlobalHandler] loadData];
    
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge > 0)
    {
        //清除标记，清除小红圈中数字
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [[GeTuiManager sharedGeTuiInstance] setBadge:0];
    }else
        [[GeTuiManager sharedGeTuiInstance] resetBadge];
    
    //进入app时，获取远程推送的信息
    [AppFramework getGlobalHandler].isHasRemoteUserInfo = NO;
    NSDictionary *userInfoDictionary = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (userInfoDictionary)
    {
        [AppFramework getGlobalHandler].isHasRemoteUserInfo = YES;
        [AppFramework getGlobalHandler].remoteUserInfoDictionary = [NSDictionary dictionaryWithDictionary:userInfoDictionary];
    }
    
    //进入首个页面
    [self.objUILayer appUIBegin];
    
    //获取启动页面停留的时间
    CGFloat timeout = 2.0;
    NSDictionary *datasDict = [_LOGIC getNSDictionaryForKey:COMMON_JFZ_LAUNCH_INFO_TAG];
    if (datasDict.count > 0) {
        timeout = [[datasDict objectForKey:@"showTime"] floatValue];
        if (timeout < 0.001) {
            timeout = 2.0f;
        }
    }
    [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(LaunchTimeOut) userInfo:nil repeats:NO];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [AppFramework getGlobalHandler].frontStatus = NO; //一定要放最前面
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_APP_FROM_FRONT_TO_BACK object:nil];
    [((CustomApplication *)application) enterBackgroundMode];
    
    //将uiwindow类型的试图给移除掉
    [[AppFramework getGlobalHandler] removePopupView];
    [[AppFramework getGlobalHandler] removePopupCtrl];
    
    //判断当前顶层是否时发送消息视图，如果是则退出消息发送视图
    if([_UI isExistModeControllerShow:@"CKSMSComposeController"])
    {
        [_UI dismissNaviModalViewCtrlAnimated:YES];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[[AppFramework getObj] globalHandler] removePopupView];
    [AppFramework getGlobalHandler].frontStatus = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_APP_FROM_BACK_TO_FRONT object:nil];
    [((CustomApplication *)application) enterFrontMode];
    
    
    //进入app设置badge为0
    //获取应用程序消息通知标记数（即小红圈中的数字）
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge > 0)
    {
        //清除标记，清除小红圈中数字
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [[GeTuiManager sharedGeTuiInstance] setBadge:0];
    }else
        [[GeTuiManager sharedGeTuiInstance] resetBadge];
    
    //刷新最新数据
    [[AppFramework getGlobalHandler] refreshNewData];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:XN_SHOW_FINGER_PASSWORD_NOTIFICATION object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{

    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //上传deviceToken到环信sdk
    [[IMManager defaultIMManager] imManagerUploadApplicationToken:deviceToken FromApplication:application];
    
    //向个推服务器注册deviceToken
    [[GeTuiManager sharedGeTuiInstance] registerDeviceToken:deviceTokenString];
    
}

//ios10中app处于前台的时候，用于是否定制通知（本地通知与远程通知统一调用以下两个方法)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0)
{
    //获取应用程序消息通知标记数（即小红圈中的数字）
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge > 0)
    {
        //清除标记，清除小红圈中数字
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [[GeTuiManager sharedGeTuiInstance] setBadge:0];
    }else
        [[GeTuiManager sharedGeTuiInstance] resetBadge];

    //如果已经退出登录，则直接进入登录页
    if ([[_LOGIC getValueForKey:XN_USER_USER_TOKEN_EXPIRED] isEqualToString:@"1"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    //根据APP需要，判断是否要提示用户相关的badge,sound,alert
    completionHandler(UNNotificationPresentationOptionBadge| UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//ios10中app处于后台的时候，用户点击通知进入前台触发
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)())completionHandler
{
    [[GeTuiManager sharedGeTuiInstance] setLaunchStatus:NO];
    
    //获取应用程序消息通知标记数（即小红圈中的数字）
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge > 0)
    {
        //清除标记，清除小红圈中数字
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [[GeTuiManager sharedGeTuiInstance] setBadge:0];
    }else
        [[GeTuiManager sharedGeTuiInstance] resetBadge];
    
    //个推统计点击转化率
    [[GeTuiManager sharedGeTuiInstance] handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}

//ios10之前的接受远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[GeTuiManager sharedGeTuiInstance] setLaunchStatus:NO];
    
    //获取应用程序消息通知标记数（即小红圈中的数字）
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge > 0)
    {
        //清除标记，清除小红圈中数字
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [[GeTuiManager sharedGeTuiInstance] setBadge:0];
    }else
        [[GeTuiManager sharedGeTuiInstance] resetBadge];
    
    //统计APNS 通知的点击数
    [[GeTuiManager sharedGeTuiInstance] handleRemoteNotification:userInfo];
}

//ios10之前的接受本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //获取应用程序消息通知标记数（即小红圈中的数字）
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge > 0)
    {
        //清除标记，清除小红圈中数字
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [[GeTuiManager sharedGeTuiInstance] setBadge:0];
    }else
        [[GeTuiManager sharedGeTuiInstance] resetBadge];
}

//app处于后台模式的时候触发，用于app处于后台的时候来获取通知信息（ios10之前，点击推送进入app会调用此函数，原来函数（上）不调用了。
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    //ios10之前的，点击推送调用此方法
    if([AppFramework getGlobalHandler].frontStatus && [[[UIDevice currentDevice] systemVersion] integerValue] < 10)
    {
        //对相关的推送做处理
        [[GeTuiManager sharedGeTuiInstance] setLaunchStatus:NO];
    }
    
    //设置了静默推送处理
    completionHandler(UIBackgroundFetchResultNewData);
}

//app后台刷新数据
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    
    /// Background Fetch   SDK
    [[GeTuiManager sharedGeTuiInstance] resume];
    
    //设置了静默推送处理
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - 分享操作处理
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"lcds"]) {
        
        NSString * jsonStr = [ [[url.absoluteString componentsSeparatedByString:@"?"] lastObject] debase64];
        
        if (![NSObject isValidateInitString:jsonStr]) {
            
            return YES;
        }
        
        NSData * jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError * error = nil;
        id params = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSString * targetName = [params objectForKey:@"name"];
        NSString * methodName = [params objectForKey:@"method"];
        NSString * paramsStr = [params objectForKey:@"params"];
        
        if ([targetName isEqualToString:@"HomeViewController"]) {
            
            [_UI currentViewController:_UI.tabBarNaviCtrl popToRootViewController:YES AndSwitchToTabbarIndex:0 comlite:nil];
            return YES;
        }else if([targetName isEqualToString:@"AgentContainerViewController"])
        {
            UINavigationController * platformCtrl = [_UI getRootNavigationControllerAtIndex:1];
            AgentContainerController * agentCtrl = platformCtrl.viewControllers[0];
            
            NSArray * paramArray = [paramsStr componentsSeparatedByString:@","];
            [agentCtrl selectedAtIndex:[[paramArray firstObject] integerValue]];
            
            [_UI currentViewController:_UI.tabBarNaviCtrl popToRootViewController:YES AndSwitchToTabbarIndex:1 comlite:nil];
            
            return YES;
        }else if([targetName isEqualToString:@"SeekTreasureViewController"])
        {
        
            [_UI currentViewController:_UI.tabBarNaviCtrl popToRootViewController:YES AndSwitchToTabbarIndex:2 comlite:nil];
            
            return YES;
        }else if([targetName isEqualToString:@"MyInfoViewController"])
        {
            [_UI currentViewController:_UI.tabBarNaviCtrl popToRootViewController:YES AndSwitchToTabbarIndex:3 comlite:nil];
            
            return YES;
        }
        
        Class VC = NSClassFromString(targetName);
        SEL method = NSSelectorFromString(methodName);
        NSArray * paramArray = [paramsStr componentsSeparatedByString:@","];
        
        // 方法签名(方法的描述)
        NSMethodSignature *signature = [VC instanceMethodSignatureForSelector:method];
        if (signature == nil)
        {
            [NSException raise:@"签名无效" format:@"%@方法找不到", NSStringFromSelector(method)];
        }
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        id obj = [VC alloc];
        invocation.target = obj;
        invocation.selector = method;
        
        //设置参数
        NSInteger nParamCount = paramArray.count; //除self、_cmd以外的参数个数
        for (NSInteger i = 0; i < nParamCount; i++)
        {
            id object = paramArray[i];
            
            if ([object isEqualToString:@"nil"])
            {
                object = [NSBundle mainBundle];
                [invocation setArgument:&object atIndex:i + 2];
            }else
            {
                //根据函数签名获取对应参数的类型：
                const char * argumentType = [signature getArgumentTypeAtIndex:i + 2];
                switch (argumentType[0] == 'r'?argumentType[1] : argumentType[0]) {
                        
                    case 'i':
                    {
                        int val = [[NSString stringWithFormat:@"%@",object] intValue];
                        [invocation setArgument:&val atIndex:i + 2];
                    }
                        break;
                    case 'q':
                    {
                        NSInteger val = [[NSString stringWithFormat:@"%@",object] integerValue];
                        [invocation setArgument:&val atIndex:i + 2];
                    }
                        break;
                        
                    case 'f':
                    {
                        float val = [[NSString stringWithFormat:@"%@",object] floatValue];
                        [invocation setArgument:&val atIndex:i+2];
                    }
                        break;
                    case 'B':
                    {
                        BOOL val = [[NSString stringWithFormat:@"%@",object] boolValue];
                        [invocation setArgument:&val atIndex:i + 2];
                    }
                        break;
                    default:
                    {
                        [invocation setArgument:&object atIndex:i + 2];
                    }
                        break;
                }
            }
        }
        
        [invocation retainArguments];
        
        //调用方法
        [invocation invoke];
        
        __autoreleasing UIViewController * value=nil;
        
        // 有返回值类型，才去获得返回值
        if (signature.methodReturnLength)
        {
            [invocation getReturnValue:&value];
        }
        
        [((UIViewController *)value) setNeedNewSwitchViewAnimation:YES];
        
        NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
        if (![NSObject isValidateInitString:token]) {
            
            [((UIViewController *)value) setSwitchToHomePage:NO];
        }
        
        [_UI pushViewControllerFromRoot:value animated:YES];
        
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WXAPPLICATIONHANDLEOPENURLNOTIFICATION object:url];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    if ([url.scheme isEqualToString:@"lcds"]) {
        
        NSString * jsonStr = [[[url.absoluteString componentsSeparatedByString:@"?"] lastObject] debase64];
        if (![NSObject isValidateInitString:jsonStr]) {
            
            return YES;
        }
        
        NSData * jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError * error = nil;
        id params = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSString * targetName = [params objectForKey:@"name"];
        NSString * methodName = [params objectForKey:@"method"];
        NSString * paramsStr = [params objectForKey:@"params"];
        
        if ([targetName isEqualToString:@"HomeViewController"]) {
            
            [_UI currentViewController:_UI.tabBarNaviCtrl popToRootViewController:YES AndSwitchToTabbarIndex:0 comlite:nil];
            
            return YES;
        }else if([targetName isEqualToString:@"AgentContainerViewController"])
        {
            UINavigationController * platformCtrl = [_UI getRootNavigationControllerAtIndex:1];
            AgentContainerController * agentCtrl = platformCtrl.viewControllers[0];
            
            NSArray * paramArray = [paramsStr componentsSeparatedByString:@","];
            [agentCtrl selectedAtIndex:[[paramArray firstObject] integerValue]];
            
            [_UI currentViewController:_UI.tabBarNaviCtrl popToRootViewController:YES AndSwitchToTabbarIndex:1 comlite:nil];
            
            return YES;
        }else if([targetName isEqualToString:@"SeekTreasureViewController"])
        {
            
            [_UI currentViewController:_UI.tabBarNaviCtrl popToRootViewController:YES AndSwitchToTabbarIndex:2 comlite:nil];
            
            return YES;
        }else if([targetName isEqualToString:@"MyInfoViewController"])
        {
            [_UI currentViewController:_UI.tabBarNaviCtrl popToRootViewController:YES AndSwitchToTabbarIndex:3 comlite:nil];
            
            return YES;
        }
        
        Class VC = NSClassFromString(targetName);
        SEL method = NSSelectorFromString(methodName);
        NSArray * paramArray = [paramsStr componentsSeparatedByString:@","];
        
        // 方法签名(方法的描述)
        NSMethodSignature *signature = [VC instanceMethodSignatureForSelector:method];
        if (signature == nil)
        {
            [NSException raise:@"签名无效" format:@"%@方法找不到", NSStringFromSelector(method)];
        }
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        id obj = [VC alloc];
        invocation.target = obj;
        invocation.selector = method;
        
        //设置参数
        NSInteger nParamCount = paramArray.count; //除self、_cmd以外的参数个数
        for (NSInteger i = 0; i < nParamCount; i++)
        {
            id object = paramArray[i];
            
            if ([object isEqualToString:@"nil"])
            {
                object = [NSBundle mainBundle];
                [invocation setArgument:&object atIndex:i + 2];
            }else
            {
                //根据函数签名获取对应参数的类型：
                const char * argumentType = [signature getArgumentTypeAtIndex:i + 2];
                switch (argumentType[0] == 'r'?argumentType[1] : argumentType[0]) {
                        
                    case 'i':
                    {
                        int val = [[NSString stringWithFormat:@"%@",object] intValue];
                        [invocation setArgument:&val atIndex:i + 2];
                    }
                        break;
                    case 'q':
                    {
                        NSInteger val = [[NSString stringWithFormat:@"%@",object] integerValue];
                        [invocation setArgument:&val atIndex:i + 2];
                    }
                        break;
                        
                    case 'f':
                    {
                        float val = [[NSString stringWithFormat:@"%@",object] floatValue];
                        [invocation setArgument:&val atIndex:i+2];
                    }
                        break;
                    case 'B':
                    {
                        BOOL val = [[NSString stringWithFormat:@"%@",object] boolValue];
                        [invocation setArgument:&val atIndex:i + 2];
                    }
                        break;
                    default:
                    {
                        [invocation setArgument:&object atIndex:i + 2];
                    }
                        break;
                }
            }
        }
        
        [invocation retainArguments];
        
        //调用方法
        [invocation invoke];
        
        __autoreleasing UIViewController * value=nil;
        
        // 有返回值类型，才去获得返回值
        if (signature.methodReturnLength)
        {
            [invocation getReturnValue:&value];
        }
        
        [((UIViewController *)value) setNeedNewSwitchViewAnimation:YES];
        
        NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
        if (![NSObject isValidateInitString:token]) {
            
            [((UIViewController *)value) setSwitchToHomePage:NO];
        }
       
        [_UI pushViewControllerFromRoot:value animated:YES];
        
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WXAPPLICATIONHANDLEOPENURLNOTIFICATION object:url];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WXAPPLICATIONHANDLEOPENURLNOTIFICATION object:url];
    
    return YES;
}

///////////////////////////////////////////////
#pragma mark - Custom Methods
//////////////////////////////////////////////////////////////////////////

#pragma mark - 项目配置设置
- (void)configXLFramework
{
    AppFramework* framework = [AppFramework getObj];
    framework.mainWindow = self.window;
    
    //框架资源配置
    AppFrameworkConfig* config = [AppFramework getConfig];
    config.imgTabBarBK = @"tabbar_bg.png";
    config.imgNaviBK = @"menu_bar_bg.png";
    config.imgNaviBackBtnNormal = @"navi_back_btn_normal.png";
    config.imgNaviBackBtnDown = @"navi_back_btn_down.png";
    config.imgTabBarBtnDownIndex1 = @"tab_bar_topic_hover";
    config.imgTabBarBtnNormalIndex1 = @"tab_bar_topic_normal";
    config.imgTabBarBtnDownIndex2 = @"tab_bar_circle_hover";
    config.imgTabBarBtnNormalIndex2 = @"tab_bar_circle_normal";
    config.imgTabBarBtnDownIndex3 = @"tab_bar_history_hover";
    config.imgTabBarBtnNormalIndex3 = @"tab_bar_history_normal";
    config.imgTabBarBtnDownIndex4 = @"tab_bar_user_hover";
    config.imgTabBarBtnNormalIndex4 = @"tab_bar_user_normal";
    config.navBgColor =[UIColor whiteColor];
    config.navBgTitleColor = [UIColor whiteColor];
    
    // 框架参数数据配置
    GlobalValueConfig myVC = [AppFramework getConfig].vc;
    myVC.sAlertInsets = UIEdgeInsetsMake(180, 30, 34, 34);
    myVC.fNaviDefHeight = 44;
    myVC.fNaviBtnDefHeight = 31;
    myVC.fNaviBKLeftCap = 2;
    myVC.fNaviBKTopCap = 30;
    myVC.fNaviBackBtnLeftCap = 32;
    myVC.fNaviBackBtnTopCap = 0;
    myVC.fNaviBackBtnMaxWidth = 150;
    myVC.fNaviBtnLeftCap = 16;
    myVC.fNaviBtnTopCap = 16;
    myVC.fNaviBtnMaxWidth = 150;
    myVC.fNaviImgBtnDefWidth = 29;
    myVC.fNaviImgBtnDefHeight = 29;
    myVC.fTabBarDefHeight = 44;
    myVC.fTabBarBKLeftCap = 11;
    myVC.fTabBarBKTopCap = 30;
    
    [AppFramework getConfig].vc  = myVC;
}

#pragma mark - 启动个推
- (void)loadGTNotificationWithApplication:(UIApplication *)application
{
    //启动个推
    [[GeTuiManager sharedGeTuiInstance] initGeTuiAppId:[AppFramework getConfig].GETUI_APPID appKey:[AppFramework getConfig].GETUI_APPKEY appSecret:[AppFramework getConfig].GETUI_APPSECRET];
    [[GeTuiManager sharedGeTuiInstance] setLaunchStatus:YES];
    
    // 判读系统版本是否是“iOS 8.0”以上
    if([[[UIDevice currentDevice] systemVersion] integerValue] >= 10.0){
        
        // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        
        //设置通知选项
        [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
        
        //启动获取设备token
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else if (([[[UIDevice currentDevice] systemVersion] integerValue] >= 8.0 && [[[UIDevice currentDevice] systemVersion] integerValue] < 10.0)
              && [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] setDelegate:self];
        
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        //启动获取设备token
        [application registerForRemoteNotifications];
        
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

#pragma mark - 启动页面超时处理
- (void)LaunchTimeOut
{
    [_UI endShowingSplashView];
}

@end
