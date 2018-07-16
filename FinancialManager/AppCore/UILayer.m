//
//  UILayer.m
//  XN
//
//  Created by liaochangping on 15-12-18.
//  Copyright (c) 2015年 xn. All rights reserved.
//

#import "UILayer.h"
#import "LogicLayer.h"
#import "objc/runtime.h"
#import "UIViewController+Extend.h"
#import "GeTuiManager.h"
#import "UIView+animation.h"

#import "GXQMainWindow.h"
#import "AppFramework.h"
#import "CustomTabBarController.h"
#import "GXQNavigationController.h"

#import "LaunchViewController.h"
#import "GuideViewController.h"
#import "AdViewController.h"

#import "HomeViewController.h"
#import "SeekTreasureViewController.h"
#import "MyInfoViewController.h"
#import "AgentContainerController.h"

#import "UseLoginViewController.h"
#import "XNSetGesturePasswordViewController.h"
#import "XNUnlockByGestureViewController.h"
#import "XNNewUserController.h"

#import "PopAnimation.h"
#import "PushAnimation.h"
#import "NavigationInteractAnimation.h"
#import "PresentAnimation.h"
#import "DismissAnimation.h"

#define CREATE_CONTROLLER(name, nibName, controllerClass, vnavigationBarHidden, tabtitle) \
controllerClass *name##Ctrl = [[controllerClass alloc] initWithNibName:nibName bundle:nil];\
name##Ctrl.title = tabtitle;\
name##Ctrl.customNavigationBarHide = vnavigationBarHidden;\
GXQNavigationController *name##ViewCtrl = [[GXQNavigationController alloc] initWithRootViewController: name##Ctrl];\
name##ViewCtrl.navigationBarHidden = vnavigationBarHidden;\
name##ViewCtrl.view.backgroundColor = [UIColor whiteColor];\

//全局导航控制器/控制器容器
static  NSMutableArray         * navigationRootViewControllerArray = nil;
static  NSMutableArray         * presentModalViewControllerArray = nil;

@interface UILayer()<UseLoginViewControllerDelegate,UITabBarControllerDelegate,UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL newAppVersion;
@property (nonatomic, assign) BOOL showAdStatus;//是否已经显示过广告
@property (nonatomic, assign) NSInteger oldSelectedIndex;

//进行页面切换效果更换属性
@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, assign) BOOL currentNavigationBarHideStatus;
@property (nonatomic, assign) BOOL currentTabBarHideStatus;

@property (nonatomic, strong) PresentAnimation * presentAnimation;
@property (nonatomic, strong) DismissAnimation * dismissAnimation;
@property (nonatomic, strong) PushAnimation * pushAnimation;
@property (nonatomic, strong) PopAnimation * popAnimation;
@property (nonatomic, strong) NavigationInteractAnimation * navigationInteractAnimation;
@end

@implementation UILayer

- (id)init
{
    if (self = [super init]) {
        
        //全局静态数组
        if (navigationRootViewControllerArray == nil) {
            
            navigationRootViewControllerArray = [[NSMutableArray alloc]init];
        }
        
        if (presentModalViewControllerArray == nil) {
            
            presentModalViewControllerArray = [[NSMutableArray alloc]init];
        }
        
        //设置默认值
        self.modellingOperation = NO;
        self.newAppVersion = NO;
        self.showAdStatus = NO;
        self.finishedInitStart = NO;
        self.currentNavigationBarHideStatus = YES;
        self.currentTabBarHideStatus = YES;
        
        [self CreateObjects];
    }
    
    return self;
}

/////////////////////////////////////////
#pragma mark - 自定义方法汇总
//////////////////////////////////////////////////////////////////////

#pragma mark - 创建显示的对象
- (void)CreateObjects
{
    // 创建主窗口
    self.mainWindow = [[GXQMainWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [AppFramework getObj].mainWindow = self.mainWindow;
    
    CREATE_CONTROLLER(home, @"HomeViewController", HomeViewController,NO, @"首页");
    CREATE_CONTROLLER(product, @"AgentContainerController", AgentContainerController,NO, @"");
    CREATE_CONTROLLER(lieCai,@"SeekTreasureViewController",SeekTreasureViewController,NO,@"猎财");
    CREATE_CONTROLLER(myInfo, @"MyInfoViewController", MyInfoViewController,NO, @"");
    
    self.rootTabBarCtrl = [[CustomTabBarController alloc] init];
    
    
    _rootTabIndexes.iHome = [self.rootTabBarCtrl addViewController:homeViewCtrl
                                                     imgUnselected:[_SKIN getHomeItemIcon:SkinType_normal]
                                                       imgSelected:[_SKIN getHomeItemIcon:SkinType_select]];
    
    _rootTabIndexes.iAgent = [self.rootTabBarCtrl addViewController:productViewCtrl
                                                      imgUnselected:[_SKIN getAgentItemIcon:SkinType_normal]
                                                        imgSelected:[_SKIN getAgentItemIcon:SkinType_select]];
    
    _rootTabIndexes.iLeiCai = [self.rootTabBarCtrl addViewController:lieCaiViewCtrl
                                                       imgUnselected:[_SKIN getLeiCaiItemIcon:SkinType_normal]
                                                         imgSelected:[_SKIN getLeiCaiItemIcon:SkinType_select]];
    
    _rootTabIndexes.iMyInfo = [self.rootTabBarCtrl addViewController:myInfoViewCtrl
                                                       imgUnselected:[_SKIN getMyInfoItemIcon:SkinType_normal]
                                                         imgSelected:[_SKIN getMyInfoItemIcon:SkinType_select]];
    
    self.rootTabBarCtrl.delegate = self;
    [self.rootTabBarCtrl refreshView];
    self.rootTabBarCtrl.selectedIndex = 0;
    
    self.mainWindow.rootViewController = self.rootTabBarCtrl;
    [navigationRootViewControllerArray addObject:self.tabBarNaviCtrl];
    [presentModalViewControllerArray addObject:self.rootTabBarCtrl];
    
    [self.mainWindow makeKeyAndVisible];
}

#pragma mark - 启动App
- (void)appUIBegin
{
    // 设置第一个页面
    LaunchViewController* launchViewController = [[LaunchViewController alloc] initWithNibName:@"LaunchViewController" bundle:nil];
    
    [_UI switchToViewCtrl:launchViewController
                 animated:NO
              animateType:kUILayerViewSwitchAnimateTypeFade
                 duration:1.0
                isForward:YES];
}

#pragma mark - 启动广告
- (void)appShowAdView
{
    //添加广告页面
    AdViewController * adController=  [[AdViewController alloc]initWithNibName:@"AdViewController" bundle:nil];
    
    [_UI switchToViewCtrl:adController
                 animated:YES
              animateType:kUILayerViewSwitchAnimateTypeFade
                 duration:2.0
                isForward:YES];
}

#pragma mark - 进入内容页面
- (void)endShowingSplashView
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *localAppVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *oldVersion = [_LOGIC getValueForKey:COMMON_APP_OLD_VERISON_TAG];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    if ([NSString isVersion:localAppVersion NewerThanVersion:oldVersion])
    {
        GuideViewController * guideViewController = [[GuideViewController alloc] initWithNibName:@"GuideViewController" bundle:nil];
        self.newAppVersion = YES;
        
        [_UI switchToViewCtrl:guideViewController
                     animated:YES
                  animateType:kUILayerViewSwitchAnimateTypeFade
                     duration:3.0
                    isForward:YES];
        [_LOGIC saveValueForKey:COMMON_APP_OLD_VERISON_TAG Value:localAppVersion];
    }
    else if([AppFramework getGlobalHandler].adLoadingSuccess && !self.showAdStatus) { //如果是存在广告页面，则显示广告页面
        
        [AppFramework getGlobalHandler].adLoadingSuccess = NO;
        self.showAdStatus = YES;
        [_UI appShowAdView];
    }else
    {
        [self enterMainPage];
        self.finishedInitStart = YES;
        
        //判断是否有token失效，如果存在则弹出登陆界面
        [_LOGIC saveValueForKey:XN_USER_ENTER_MAIN_INTERFACE Value:@"1"];
        
        //判断是否是新app
        if (self.newAppVersion) {
            
            self.newAppVersion = NO;
            
            [_LOGIC saveValueForKey:XN_USER_INSURANCE_NEWUSER_TAG Value:@"1"];
            [_LOGIC saveValueForKey:XN_USER_HOME_NEWUSER_KNOW_US_TAG Value:@"1"];
            [_LOGIC saveValueForKey:XN_USER_FIRST_ENTER_APP Value:@"YES"];
            [_LOGIC saveValueForKey:COMMON_APP_PUSH_NOTIFICATION_DISTURBED_TAG Value:@"0"];
            [_LOGIC saveValueForKey:XN_MY_PROFIT_WARNING_TAG Value:@"1"];
            [_LOGIC saveValueForKey:XN_MY_LEADER_WARNING_TAG Value:@"1"];

            [_LOGIC saveValueForKey:XN_USER_SEEK_TREASURE_ACTIVITY Value:@"1"];
            [_LOGIC saveValueForKey:XN_USER_AGENT_CONTAINER_INSURANCE Value:@"1"];
            
            [XNNewUserController defaultObj];
        }
        
        //开始刷新
        [self.tabBarNaviCtrl viewWillAppear:YES];
        [self.tabBarNaviCtrl viewDidAppear:YES];
    
        [[GeTuiManager sharedGeTuiInstance] setLaunchStatus:NO];
        
        NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
        if ([NSObject isValidateInitString:token] && [[_LOGIC getValueForKey:XN_USER_GESTURE_INPUT_ERROR_COUNT_TAG] integerValue] > 0) {
            
            MIUnlockPasswordContainerController * setGestureCtrl = [[MIUnlockPasswordContainerController alloc]initWithNibName:@"MIUnlockPasswordContainerController" bundle:nil];
            
            [_UI presentNaviModalViewCtrl:setGestureCtrl animated:!([_LOGIC integerForKey:XN_USER_FINGER_PASSWORD_SET] ==1) NavigationController:YES hideNavigationBar:YES navigationBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6] modalPresentationStyle:UIModalPresentationOverCurrentContext completion:^{
                
            }];
        }
    }
}

#pragma mark - 返回对应的root导航器
- (UINavigationController *)tabBarNaviCtrl
{
    if([[self.rootTabBarCtrl selectedViewController] isKindOfClass:[UINavigationController class]]){
        
        return (UINavigationController *)[self.rootTabBarCtrl selectedViewController];
    }
    return nil;
}

#pragma mark - 添加试图入根试图中
- (void)switchToViewCtrl:(UIViewController*)viewCtrl
                animated:(BOOL)animated
             animateType:(UILayerViewSwitchAnimateType)animateType
                duration:(CGFloat)duration
               isForward:(BOOL)isForward
{
    if (viewCtrl == nil)
    {
        return ;
    }
    
    if (self.currentViewCtrl == nil)
    {
        [self.rootTabBarCtrl.view addSubview:viewCtrl.view];
        self.currentViewCtrl = viewCtrl;
        
        __weak UIView * tmpRootTabBarView = self.rootTabBarCtrl.view;
        [viewCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpRootTabBarView);
        }];
        
        return ;
    }
    
    if (animated == NO) {
        
        [self.rootTabBarCtrl.view addSubview:viewCtrl.view];
        [self.currentViewCtrl.view removeFromSuperview];
        self.currentViewCtrl = viewCtrl;
        
        __weak UIView * tmpRootTabBarView = self.rootTabBarCtrl.view;
        [viewCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpRootTabBarView);
        }];
        
        return;
    }
    
    [self.currentViewCtrl.view.layer removeAllAnimations];
    if (animateType == kUILayerViewSwitchAnimateTypeFade)
    {
        [self.currentViewCtrl.view removeFromSuperview];
        [self.rootTabBarCtrl.view addSubview:viewCtrl.view];
        self.currentViewCtrl = viewCtrl;
        
        __weak UIView * tmpRootTabBarView = self.rootTabBarCtrl.view;
        [viewCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpRootTabBarView);
        }];
        
        [self.rootTabBarCtrl.view applyFadeAnimationWithKey:@"fade" duration:duration];
        
        return ;
    }else if(animateType == kUILayerViewSwitchAnimateTypeBigger){
        
        [self.rootTabBarCtrl.view insertSubview:viewCtrl.view belowSubview:self.currentViewCtrl.view];
        
        __weak UIView * tmpRootTabBarView = self.rootTabBarCtrl.view;
        [viewCtrl.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(tmpRootTabBarView);
        }];
        
        [UIView animateWithDuration:duration animations:^{
            
            self.currentViewCtrl.view.transform = CGAffineTransformMakeScale(2.0, 2.0);
            self.currentViewCtrl.view.alpha = 0;
        } completion:^(BOOL finished) {
            
            [self.currentViewCtrl.view removeFromSuperview];
            self.currentViewCtrl = viewCtrl;
        }];
        return;
    }
}

//进入主界面动画
- (void)enterMainPage
{
    [UIView animateWithDuration:3.0f animations:^{
        
        self.currentViewCtrl.view.transform = CGAffineTransformMakeScale(2.0, 2.0);
        self.currentViewCtrl.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.currentViewCtrl.view removeFromSuperview];
        self.currentViewCtrl = nil;
    }];
}

#pragma mark - 模态跳转
- (void)presentNaviModalViewCtrl:(UIViewController*)ctrl animated:(BOOL)animated NavigationController:(BOOL)navi hideNavigationBar:(BOOL)hide completion: (void (^)(void))completion
{
    [self presentNaviModalViewCtrl:ctrl animated:animated NavigationController:navi hideNavigationBar:hide navigationBackgroundColor:nil modalPresentationStyle:UIModalPresentationFullScreen completion:completion];
}

- (void)presentNaviModalViewCtrl:(UIViewController*)ctrl animated:(BOOL)animated NavigationController:(BOOL)navi hideNavigationBar:(BOOL)hide navigationBackgroundColor:(UIColor *)bgColor modalPresentationStyle:(UIModalPresentationStyle) style completion: (void (^)(void))completion
{
    if (!self.modellingOperation) {
        
        self.modellingOperation = YES;
        
        [ctrl setCustomNavigationBarHide:hide];
        
        weakSelf(weakSelf)
        if (navi) {
            
            ctrl.needNewSwitchViewAnimation = hide;
            GXQNavigationController * navigationCtrl = [[GXQNavigationController alloc]initWithRootViewController:ctrl];
            
            navigationCtrl.view.backgroundColor = bgColor;
            navigationCtrl.modalPresentationStyle = style;
            
            [navigationCtrl setNavigationBarHidden:hide];
            [navigationRootViewControllerArray addObject:navigationCtrl];
            
            if (presentModalViewControllerArray.count > 1)
                
                [[presentModalViewControllerArray lastObject] viewWillDisappear:YES];
            else
                [self.tabBarNaviCtrl viewWillDisappear:YES];
            
            __weak UIViewController * tmpController = [presentModalViewControllerArray lastObject];
            
            if ([ctrl isKindOfClass:[UseLoginViewController class]] && ((UseLoginViewController *)ctrl).showNewAnimation) {
                
                [[presentModalViewControllerArray lastObject] setTransitioningDelegate:self];
                navigationCtrl.transitioningDelegate = self;
            }
            
            [[presentModalViewControllerArray lastObject] presentViewController:navigationCtrl animated:animated completion:^{
                
                weakSelf.modellingOperation = NO;
                [tmpController viewDidDisappear:YES];
                if ([NSObject isValidateObj:completion])
                    completion();
            }];
            [presentModalViewControllerArray addObject:navigationCtrl];
        }else
        {
            if (presentModalViewControllerArray.count > 1)
                [[presentModalViewControllerArray lastObject] viewWillDisappear:YES];
            else
                [self.tabBarNaviCtrl viewWillDisappear:YES];
            
            __weak UIViewController * tmpController = [presentModalViewControllerArray lastObject];
            [[presentModalViewControllerArray lastObject] presentViewController:ctrl animated:animated completion:^{
                
                weakSelf.modellingOperation = NO;
                [tmpController viewDidDisappear:YES];
                if ([NSObject isValidateObj:completion])
                    completion();
            }];
            [presentModalViewControllerArray addObject:ctrl];
        }
    }
}

- (void)presentNaviModalViewCtrl:(UIViewController*)ctrl animated:(BOOL)animated NavigationController:(BOOL)navi completion: (void (^)(void))completion
{
    [self presentNaviModalViewCtrl:ctrl animated:animated NavigationController:navi hideNavigationBar:NO completion:completion];
}

- (void)presentNaviModalViewCtrl:(UIViewController*)ctrl animated:(BOOL)animated completion: (void (^)(void))completion
{
    [self presentNaviModalViewCtrl:ctrl animated:animated NavigationController:NO hideNavigationBar:NO completion:completion];
}

- (void)presentNaviModalViewCtrl:(UIViewController*)ctrl animated:(BOOL)animated
{
    [self presentNaviModalViewCtrl:ctrl animated:animated NavigationController:NO hideNavigationBar:NO completion:nil];
}

#pragma mark - 退出模态
- (void)dismissNaviModalViewCtrlAnimated:(BOOL)animated
{
    [self dismissNaviModalViewCtrlAnimated:animated completion:nil];
}

- (void)dismissNaviModalViewCtrlAnimated:(BOOL)animated completion: (void (^)(void))completion
{
    if (!self.modellingOperation) {
        
        self.modellingOperation = YES;
        UIViewController * ctrl = [presentModalViewControllerArray lastObject];
        UINavigationController * navi = [navigationRootViewControllerArray lastObject];
        
        if ([navi isEqual:ctrl]) {
            
            [navigationRootViewControllerArray removeLastObject];
        }
        
        weakSelf(weakSelf)
        if (presentModalViewControllerArray.count > 1) {
            
            [presentModalViewControllerArray removeLastObject];
            [[presentModalViewControllerArray lastObject] viewWillAppear:YES];
            
            __weak UIViewController * tmpController = [presentModalViewControllerArray lastObject];
            [[presentModalViewControllerArray lastObject] dismissViewControllerAnimated:animated completion:^{
                
                weakSelf.modellingOperation = NO;
                [tmpController viewDidAppear:YES];
                if ([NSObject isValidateObj:completion])
                    completion();
            }];
        }else
        {
            //针对dismiss过程中异步过程出现其他dismiss的请求处理
            [[self topModeViewController] dismissViewControllerAnimated:YES completion:^{
                
                weakSelf.modellingOperation = NO;
                [[weakSelf topModeViewController] viewDidAppear:YES];
                if ([NSObject isValidateObj:completion])
                    completion();
            }];
        }
    }
}

#pragma mark - 入栈操作
- (void)pushViewControllerFromRoot:(UIViewController*)ctrl animated:(BOOL)animated
{
    [self pushViewControllerFromRoot:ctrl hideNavigationBar:NO animated:animated];
}

- (void)pushViewControllerFromRoot:(UIViewController *)ctrl animated:(BOOL)animated completion: (void (^)(void))completion
{
    [self pushViewControllerFromRoot:ctrl hideNavigationBar:NO animated:animated];
    
    if (completion) {
        
        completion();
    }
}

- (void)pushViewControllerFromRoot:(UIViewController*)ctrl hideNavigationBar:(BOOL)hide animated:(BOOL)animated
{
    [ctrl setHidesBottomBarWhenPushed:YES];
    [ctrl setCustomNavigationBarHide:hide];
    self.currentNavigationBarHideStatus = hide;
    
    //判断当前的视图是否是将要被推送的视图
    UINavigationController * nav = [navigationRootViewControllerArray lastObject];
    
    //针对相同的推送推送多次的问题，防止push同样的视图多次（除网页和活动向导页面）
    if ([[nav.viewControllers lastObject] isKindOfClass:object_getClass(ctrl)] && ![[nav.viewControllers lastObject] isKindOfClass: NSClassFromString(@"UniversalInteractWebViewController")] && ![[nav.viewControllers lastObject] isKindOfClass: NSClassFromString(@"ActivityGuilderController")]) {
        
        return;
    }
    
    GXQNavigationController * currentRootNavigationController = (GXQNavigationController *)[navigationRootViewControllerArray lastObject];
    
    if (ctrl.needNewSwitchViewAnimation) {
        
        ctrl.navigationController.delegate = self;
        currentRootNavigationController.delegate = self;
    }else
    {
        ctrl.navigationController.delegate = currentRootNavigationController.systemDelegate;
        currentRootNavigationController.delegate = currentRootNavigationController.systemDelegate;
    }

    [currentRootNavigationController pushViewController:ctrl animated:YES];
    [currentRootNavigationController setNavigationBarHidden:hide];
}

//针对从首页推出的
- (void)pushViewControllerFromHomeViewControllerForController:(UIViewController*)ctrl hideNavigationBar:(BOOL)hide animated:(BOOL)animated
{
    [ctrl setHidesBottomBarWhenPushed:YES];
    [ctrl setCustomNavigationBarHide:hide];
    self.currentNavigationBarHideStatus = hide;
    
    //判断当前的视图是否是将要被推送的视图
    UINavigationController * nav = [navigationRootViewControllerArray lastObject];
    
    //针对相同的推送推送多次的问题，防止push同样的视图多次（除网页和活动向导页面）
    if ([[nav.viewControllers lastObject] isKindOfClass:object_getClass(ctrl)] && ![[nav.viewControllers lastObject] isKindOfClass: NSClassFromString(@"UniversalInteractWebViewController")] && ![[nav.viewControllers lastObject] isKindOfClass: NSClassFromString(@"ActivityGuilderController")]) {
        
        return;
    }
    
    //判断当前的视图是否是将要被推送的视图
    GXQNavigationController * currentRootNavigationController = (GXQNavigationController *)[navigationRootViewControllerArray firstObject];
    
    if (ctrl.needNewSwitchViewAnimation) {
       
        ctrl.navigationController.delegate = self;
        currentRootNavigationController.delegate = self;
    }else
    {
        ctrl.navigationController.delegate = currentRootNavigationController.systemDelegate;
        currentRootNavigationController.delegate = currentRootNavigationController.systemDelegate;
    }
   
    [currentRootNavigationController pushViewController:ctrl animated:NO];
    [currentRootNavigationController setNavigationBarHidden:hide];
}

#pragma mark - 弹出栈
- (void)popViewControllerFromRootDidHideNavigationBar:(BOOL)hide animated:(BOOL)animated
{
    NSArray * ctrlArray = [[navigationRootViewControllerArray lastObject] viewControllers];
    self.currentNavigationBarHideStatus = NO;
    if (ctrlArray.count >= 2) {
     
        UIViewController * toViewCtrl = [ctrlArray objectAtIndex:ctrlArray.count - 2];
        self.currentNavigationBarHideStatus = toViewCtrl.customNavigationBarHide;
    }
    
    self.currentTabBarHideStatus = !([navigationRootViewControllerArray count] == 1 && [[navigationRootViewControllerArray firstObject] viewControllers].count == 2);
    
    UIViewController * popCtrl = [[[navigationRootViewControllerArray lastObject] viewControllers] lastObject];
    GXQNavigationController * currentRootNavigationController = (GXQNavigationController *)[navigationRootViewControllerArray lastObject];
    if (popCtrl.needNewSwitchViewAnimation) {
        
        popCtrl.navigationController.delegate = self;
        currentRootNavigationController.delegate = self;
    }else
    {
        popCtrl.navigationController.delegate = currentRootNavigationController.systemDelegate;
        currentRootNavigationController.delegate = currentRootNavigationController.systemDelegate;
    }
    
    [[navigationRootViewControllerArray lastObject] popViewControllerAnimated:animated];
}

- (void)popViewControllerFromRoot:(BOOL)animated
{
    [self popViewControllerFromRootDidHideNavigationBar:NO animated:animated];
}

- (void)popToRootViewController:(BOOL)animated{
    
    NSArray * ctrlArray = [[navigationRootViewControllerArray lastObject] viewControllers];
    UIViewController * toViewCtrl = [ctrlArray objectAtIndex:0];
    self.currentNavigationBarHideStatus = toViewCtrl.customNavigationBarHide;
    
    self.currentTabBarHideStatus = !([navigationRootViewControllerArray count] == 1);
    
    UIViewController * popCtrl = [[[navigationRootViewControllerArray lastObject] viewControllers] lastObject];
    UIViewController * rootCtrl = [[[navigationRootViewControllerArray lastObject] viewControllers] firstObject];
    GXQNavigationController * currentRootNavigationController = (GXQNavigationController *)[navigationRootViewControllerArray lastObject];
    if (rootCtrl.needNewSwitchViewAnimation) {
        
        popCtrl.navigationController.delegate = self;
        currentRootNavigationController.delegate = self;
    }else
    {
        popCtrl.navigationController.delegate = currentRootNavigationController.systemDelegate;
        currentRootNavigationController.delegate = currentRootNavigationController.systemDelegate;
    }
    
    [[navigationRootViewControllerArray lastObject] popToRootViewControllerAnimated:animated];
}

- (void)popViewControllerFromRootDidHideNavigationBar:(BOOL)hide animated:(BOOL)animated ToNavigationCtrl:(NSString  *)ctrl
{
    [self popViewControllerFromRoot:animated ToNavigationCtrl:ctrl comlite:nil];
}

#pragma mark - 慎用
- (void)popViewControllerFromRoot:(BOOL)animated ToNavigationCtrl:(NSString *)ctrlClassName comlite:(void (^)())complite
{
    if (ctrlClassName) {
        
        UIViewController * navigationCtrl = nil;
        for (UIViewController * ctrl in self.tabBarNaviCtrl.viewControllers) {
            
            if ([ctrl isKindOfClass:objc_getClass([ctrlClassName UTF8String])]) {
                
                navigationCtrl = ctrl;
                break;
            }
        }
        
        if (navigationCtrl)
        {
            self.currentNavigationBarHideStatus = [navigationCtrl customNavigationBarHide];
            self.currentTabBarHideStatus = !([navigationRootViewControllerArray count] == 1 && [[[navigationRootViewControllerArray firstObject] viewControllers] indexOfObject:navigationCtrl] == 0);
            
            UIViewController * popCtrl = [[[navigationRootViewControllerArray lastObject] viewControllers] lastObject];

            GXQNavigationController * currentRootNavigationController = (GXQNavigationController *)[navigationRootViewControllerArray lastObject];
           
            if (navigationCtrl.needNewSwitchViewAnimation) {
                
                popCtrl.navigationController.delegate = self;
                currentRootNavigationController.delegate = self;
            }else
            {
                popCtrl.navigationController.delegate = currentRootNavigationController.systemDelegate;
                currentRootNavigationController.delegate = currentRootNavigationController.systemDelegate;
            }
            
            [[navigationRootViewControllerArray lastObject] popToViewController:navigationCtrl animated:animated];
        }
    }else
    {
        UIViewController * ctrl = [[[navigationRootViewControllerArray lastObject] viewControllers] firstObject];
        
        self.currentNavigationBarHideStatus = [ctrl customNavigationBarHide];
        self.currentTabBarHideStatus = !([navigationRootViewControllerArray count] == 1);
        
        UIViewController * popCtrl = [[[navigationRootViewControllerArray lastObject] viewControllers] lastObject];
        GXQNavigationController * currentRootNavigationController = (GXQNavigationController *)[navigationRootViewControllerArray lastObject];
        
        if (ctrl.needNewSwitchViewAnimation) {
            
            popCtrl.navigationController.delegate = self;
            currentRootNavigationController.delegate = self;
        }else
        {
            popCtrl.navigationController.delegate = currentRootNavigationController.systemDelegate;
            currentRootNavigationController.delegate = currentRootNavigationController.systemDelegate;
        }
        
        [[navigationRootViewControllerArray lastObject] popToRootViewControllerAnimated:animated];
    }
    
    if (complite) {
        
        complite();
    }
}

#pragma mark - 不同根导航控制器上的控制器之间的跳转
- (void)currentViewController:(UIViewController *)viewController popToRootViewController:(BOOL)animated AndSwitchToTabbarIndex:(NSInteger)index comlite:(void (^)())complite
{
    //如果控制器在当前的堆栈中，则直接用pop的动画，否则用渐变的动画
    CATransition* animation = [CATransition animation];
    [animation setDuration:0.3f];
    [animation setType:kCATransitionFade];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    if([viewController.navigationController isEqual:[self.rootTabBarCtrl.viewControllers objectAtIndex:index]]){
        
        [_UI popToRootViewController:YES];
        if (complite) {
            
            complite();
        }
    }else{
        
        UINavigationController *navi = [_UI.rootTabBarCtrl.viewControllers objectAtIndex:index];
        
        if([navi isKindOfClass:[UINavigationController class]]){
            
            __weak UILayer *weakSelf = self;
            self.rootTabBarCtrl.tabBar.alpha = 1;
            self.rootTabBarCtrl.tabBar.barTintColor = [UIColor whiteColor];
            
            self.oldSelectedIndex = self.rootTabBarCtrl.selectedIndex;
            UINavigationController *oldNavi = [_UI.rootTabBarCtrl.viewControllers objectAtIndex:self.rootTabBarCtrl.selectedIndex];
            
            if (oldNavi.viewControllers.count <= 1) {
                
                self.rootTabBarCtrl.selectedIndex = index;
                
                //防止B页面切换到A页面的时候，此时navigationRootViewControllerArray中的tabBarNaviCtrl中的selectViewController未更新而不能进行试图的切换
                [navigationRootViewControllerArray removeObjectAtIndex:0];
                [navigationRootViewControllerArray insertObject:self.tabBarNaviCtrl atIndex:0];
                if (complite) {
                    complite();
                }
            }else
            {
                NSMutableArray *viewControllers = [navi.viewControllers mutableCopy];
                [viewControllers addObject:viewController];
                [navi setViewControllers:viewControllers animated:NO];
                self.rootTabBarCtrl.selectedIndex = index;
                
                //延时0.1秒执行，保证pop的动画不被打断
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^{
                    
                    [self.rootTabBarCtrl.view.layer addAnimation:animation forKey:nil];
                    weakSelf.rootTabBarCtrl.tabBar.barTintColor = nil;
                    
                    UINavigationController *navi = [_UI.rootTabBarCtrl.viewControllers objectAtIndex:weakSelf.rootTabBarCtrl.selectedIndex];
                    [navi popToRootViewControllerAnimated:NO];
                    [navi setNavigationBarHidden:[[navi.viewControllers firstObject] customNavigationBarHide]];
                    
                    UINavigationController * oldNavi = [_UI.rootTabBarCtrl.viewControllers objectAtIndex:weakSelf.oldSelectedIndex];
                    
                    [oldNavi setViewControllers:@[oldNavi.viewControllers[0]]];
                    [oldNavi setNavigationBarHidden:[oldNavi.viewControllers[0] customNavigationBarHide]];
                    
                    //防止B页面切换到A页面的时候，此时navigationRootViewControllerArray中的tabBarNaviCtrl中的selectViewController未更新而不能进行试图的切换
                    [navigationRootViewControllerArray removeObjectAtIndex:0];
                    [navigationRootViewControllerArray insertObject:self.tabBarNaviCtrl atIndex:0];
                    if (complite) {
                        
                        complite();
                    }
                });
            }
        }
    }
}

#pragma mark - 从某页面跳转到根视图然后跳转到相关子页面
- (void)currentViewController:(UIViewController *)viewController switchToTabbarIndex:(NSInteger)index pushToTargetViewController:(UIViewController *)targetController withAnimation:(BOOL)animated comlite:(void (^)())complite
{
    UINavigationController * nav = [_UI.rootTabBarCtrl.viewControllers objectAtIndex:index];
    if ([viewController.navigationController isEqual:nav]) {
        
        [_UI pushViewControllerFromRoot:targetController animated:YES];
        
        NSMutableArray *viewControllers = [nav.viewControllers mutableCopy];
        
        if (viewControllers.count >= 3)
            [viewControllers removeObjectAtIndex:viewControllers.count - 2];
        
        [nav setViewControllers:viewControllers animated:NO];
        
        if (complite) {
            
            complite();
        }
    }else
    {
        
        NSInteger oldIndex = _UI.rootTabBarCtrl.selectedIndex;
        
        UINavigationController * newNavi = [_UI.rootTabBarCtrl.viewControllers objectAtIndex:index];
        NSMutableArray * viewControllers = [newNavi.viewControllers mutableCopy];
        [viewControllers addObject:targetController];
        [newNavi setViewControllers:viewControllers];
        [targetController setHidesBottomBarWhenPushed:YES];
        _UI.rootTabBarCtrl.selectedIndex = index;
        
        UINavigationController * oldNavi = [_UI.rootTabBarCtrl.viewControllers objectAtIndex:oldIndex];
        NSMutableArray * oldViewControllers = [oldNavi.viewControllers mutableCopy];
        [oldNavi setViewControllers:@[oldViewControllers[0]]];
        
        //防止B页面切换到A页面的时候，此时navigationRootViewControllerArray中的tabBarNaviCtrl中的selectViewController未更新而不能进行试图的切换
        [navigationRootViewControllerArray removeObjectAtIndex:0];
        [navigationRootViewControllerArray insertObject:self.tabBarNaviCtrl atIndex:0];
        
        if (complite)
            complite();
    }
}


#pragma mark - 是否存在登入界面
- (BOOL)isExistModeControllerShow:(NSString *)controller
{
    BOOL exist = YES;
    
    UIViewController * crtl = [presentModalViewControllerArray lastObject];
    
    if ([crtl isKindOfClass:[UINavigationController class]]) {
        
        UIViewController * currentCtrl = [[(UINavigationController *)crtl viewControllers] firstObject];
        
        if (![currentCtrl isKindOfClass:NSClassFromString(controller)])
            exist = NO;
        
    }else
    {
        //防止主界面未出现之前在子界面push登入界面的时候，登入界面异常未弹出来的情况
        if (![crtl isKindOfClass:NSClassFromString(controller)])
            exist = NO;
    }
    
    return exist;
}

#pragma mark - 添加红点提示
- (void)addNormalRemindDot:(NSString *)dotImageName selectedDotImageName:(NSString *)selectedImageName atIndex:(NSInteger )index
{
    CustomTabBarController* tabBar = (CustomTabBarController*)self.rootTabBarCtrl;
    [tabBar addNormalDotImageName:dotImageName selectedDotImageName:selectedImageName atIndex:index];
}

#pragma mark - 移除红点提示
- (void)replaceRemindDotAtIndex:(NSInteger )index withNormalImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    CustomTabBarController* tabBar = (CustomTabBarController*)self.rootTabBarCtrl;
    
    [tabBar  replaceRemindDotAtIndex:index withNormalImageName:imageName selectedImageName:selectedImageName];
}

#pragma mark - 查找顶层试图
- (UIViewController *)deepestPresentedViewControllerOf:(UIViewController *)viewController
{
    if (viewController.presentedViewController) {
        return [self deepestPresentedViewControllerOf:viewController.presentedViewController];
    } else {
        return viewController;
    }
}

#pragma mark - 查找顶层试图
- (UIViewController *)topViewController
{
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIViewController *deepestPresentedViewController = [self deepestPresentedViewControllerOf:rootViewController];
    if ([deepestPresentedViewController isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)deepestPresentedViewController).topViewController;
    } else {
        return deepestPresentedViewController;
    }
}

#pragma mark - 顶部模态试图
- (UIViewController *)topModeViewController
{
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UIViewController *deepestPresentedViewController = [self deepestPresentedViewControllerOf:rootViewController];
    
    return deepestPresentedViewController;
}

//获取导航栈中顶层视图
- (UIViewController *)topController
{
    UINavigationController * nav = [navigationRootViewControllerArray lastObject];
    
    if (presentModalViewControllerArray.count != 1 && ![[presentModalViewControllerArray lastObject] isKindOfClass:[UINavigationController class]]) {
        
        UIViewController * topCtrl = [presentModalViewControllerArray lastObject];
        
        return topCtrl;
    }
    
    UIViewController * topCtrl = [nav.viewControllers lastObject];
    
    return topCtrl;
}

//获取到导航控制器中的顶层视图（对于登录操作，想获取到mode视图底下的导航控制器中的顶层视图)
- (UIViewController *)topControllerUnderLoginModelViewController
{
    UIViewController * topCtrl = [[[navigationRootViewControllerArray lastObject] viewControllers] lastObject];
    if (presentModalViewControllerArray.count != 1 && [[presentModalViewControllerArray lastObject] isKindOfClass:[UINavigationController class]]) {
        
        topCtrl = [[[navigationRootViewControllerArray objectAtIndex:([navigationRootViewControllerArray count] - 2)] viewControllers] lastObject];
    }
    
    return topCtrl;
}

//清除前一层导航
- (void)clearPreNavigationCtrl
{
    UINavigationController * nav = [navigationRootViewControllerArray lastObject];
    if (nav.viewControllers.count >= 3) {
        
        NSMutableArray * viewControllers = [nav.viewControllers mutableCopy];
        [viewControllers removeObjectAtIndex:viewControllers.count - 2];
        [nav setViewControllers:viewControllers];
    }
}

//获取到根导航控制器
- (UINavigationController *)getRootNavigationControllerAtIndex:(NSInteger)index
{
    UINavigationController * nav = self.rootTabBarCtrl.viewControllers[index];
    return nav;
}

//获取模态控制器的层次
- (UIViewController *)topModelRootViewController
{
    UIViewController * lastModelViewController = [presentModalViewControllerArray lastObject];
    
    return lastModelViewController;
}

////////////////////////////
#pragma mark - 回调
////////////////////////////////////////////////

#pragma mark - tab回调
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger index = [self.rootTabBarCtrl.viewControllers indexOfObject:viewController];
    
    [navigationRootViewControllerArray replaceObjectAtIndex:0 withObject:(UINavigationController *)viewController];
    
    switch (index) {
        case homePageTab:
            [[NSNotificationCenter defaultCenter] postNotificationName:XN_USER_SWITCH_TAB_HOMEPAGE object:nil];
            break;
        case financialManagerTab:
            [[NSNotificationCenter defaultCenter] postNotificationName:XN_USER_SWITCH_TAB_FINANCIALMANAGER object:nil];
            break;
        case leicaiTab:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:XN_USER_SWITCH_TAB_LIECAI object:nil];
        }
            break;
        case myInfoTab:
            [[NSNotificationCenter defaultCenter] postNotificationName:XN_USER_SWITCH_TAB_MYINFO object:nil];
            break;
        default:
            break;
    }
}

#pragma mark - 动画执行回调
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.currentViewCtrl.view removeFromSuperview];
}

#pragma mark - 模态自定义导航
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.presentAnimation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissAnimation;
}

#pragma mark - 导航自定义专场
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if ([animationController isKindOfClass:[PopAnimation class]]) {
        
        return self.navigationInteractAnimation.interation?self.navigationInteractAnimation:nil;
    }
    
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    self.operation = operation;
    
    if (operation == UINavigationControllerOperationPush) {
        
        [self.navigationInteractAnimation addPanGestureForViewController:toVC];
        
        return [[PushAnimation alloc]initNavigationStatus:self.currentNavigationBarHideStatus];
        
    }else if(operation == UINavigationControllerOperationPop)
    {
        return [[PopAnimation alloc]initNavigationStatus:self.currentNavigationBarHideStatus tabBarStatus:self.currentTabBarHideStatus];
    }
    
    return nil;
}

/////////////////////
#pragma mark -setter/getter
////////////////////////////////////

- (NavigationInteractAnimation *)navigationInteractAnimation
{
    if (!_navigationInteractAnimation) {
        
        _navigationInteractAnimation = [[NavigationInteractAnimation alloc]initWithTransitionType:XWInteractiveTransitionTypePop GestureDirection:XWInteractiveTransitionGestureDirectionRight];
    }
    return _navigationInteractAnimation;
}

- (PresentAnimation *)presentAnimation
{
    if (!_presentAnimation) {
        
        _presentAnimation = [[PresentAnimation alloc]init];
    }
    return _presentAnimation;
}

- (DismissAnimation *)dismissAnimation
{
    if (!_dismissAnimation) {
        
        _dismissAnimation = [[DismissAnimation alloc]init];
    }
    return _dismissAnimation;
}
@end
