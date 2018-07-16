//
//  UILayer.h
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _tagUILayerViewSwitchAnimateType
{
    kUILayerViewSwitchAnimateTypePage = 0,
    kUILayerViewSwitchAnimateTypeFlip,
    kUILayerViewSwitchAnimateTypePull,
    kUILayerViewSwitchAnimateTypeFade,
    kUILayerViewSwitchAnimateTypeBigger,
    kUILayerViewSwitchAnimateTypeMAX
} UILayerViewSwitchAnimateType;

typedef struct _tagRootTabIndexes
{
    NSInteger iHome;
    NSInteger iAgent;
    NSInteger iLeiCai;
    NSInteger iCustomerService;
    NSInteger iMyInfo;
} RootTabIndexes;

@class CustomTabBarController;
@interface UILayer : NSObject<UITabBarControllerDelegate>

@property (nonatomic, assign) BOOL    finishedInitStart;
@property (nonatomic, assign) BOOL modellingOperation;
@property (nonatomic, assign) RootTabIndexes rootTabIndexes;
@property (nonatomic, strong) UIViewController       * currentViewCtrl;
@property (nonatomic, strong) UIWindow               * mainWindow;
@property (nonatomic, strong) CustomTabBarController * rootTabBarCtrl;
@property (nonatomic, strong) UINavigationController * tabBarNaviCtrl;

#pragma mark - 启动app初始化函数
- (void)appUIBegin;
- (void)appShowAdView;
- (void)switchToViewCtrl:(UIViewController*)viewCtrl
                animated:(BOOL)animated
             animateType:(UILayerViewSwitchAnimateType)animateType
                duration:(CGFloat)duration
               isForward:(BOOL)isForward;
- (void)endShowingSplashView;

#pragma mark - 模态展示试图
- (void)presentNaviModalViewCtrl:(UIViewController*)ctrl animated:(BOOL)animated;

- (void)presentNaviModalViewCtrl:(UIViewController*)ctrl animated:(BOOL)animated completion: (void (^)(void))completion;

- (void)presentNaviModalViewCtrl:(UIViewController*)ctrl animated:(BOOL)animated NavigationController:(BOOL)navi completion: (void (^)(void))completion;

- (void)presentNaviModalViewCtrl:(UIViewController*)ctrl animated:(BOOL)animated NavigationController:(BOOL)navi hideNavigationBar:(BOOL)hide completion: (void (^)(void))completion;
- (void)presentNaviModalViewCtrl:(UIViewController*)ctrl animated:(BOOL)animated NavigationController:(BOOL)navi hideNavigationBar:(BOOL)hide navigationBackgroundColor:(UIColor *)bgColor modalPresentationStyle:(UIModalPresentationStyle) style completion: (void (^)(void))completion;

#pragma mark - 退出模态
- (void)dismissNaviModalViewCtrlAnimated:(BOOL)animated;
- (void)dismissNaviModalViewCtrlAnimated:(BOOL)animated completion: (void (^)(void))completion;

#pragma mark - 推入栈
- (void)pushViewControllerFromRoot:(UIViewController*)ctrl animated:(BOOL)animated;
- (void)pushViewControllerFromRoot:(UIViewController *)ctrl animated:(BOOL)animated completion: (void (^)(void))completion;

- (void)pushViewControllerFromRoot:(UIViewController*)ctrl hideNavigationBar:(BOOL)hide animated:(BOOL)animated;

//针对从首页推出的
- (void)pushViewControllerFromHomeViewControllerForController:(UIViewController*)ctrl hideNavigationBar:(BOOL)hide animated:(BOOL)animated;

#pragma mark - 出栈
- (void)popViewControllerFromRoot:(BOOL)animated;

- (void)popViewControllerFromRootDidHideNavigationBar:(BOOL)hide animated:(BOOL)animated;

- (void)popToRootViewController:(BOOL)animated;

- (void)popViewControllerFromRootDidHideNavigationBar:(BOOL)hide animated:(BOOL)animated ToNavigationCtrl:(NSString  *)ctrl;

- (void)popViewControllerFromRoot:(BOOL)animated ToNavigationCtrl:(NSString  *)ctrl comlite:(void (^)())complite;

#pragma mark - 不同根导航控制器上的控制器之间的跳转
- (void)currentViewController:(UIViewController *)viewController popToRootViewController:(BOOL)animated AndSwitchToTabbarIndex:(NSInteger)index comlite:(void (^)())complite;

- (void)currentViewController:(UIViewController *)viewController switchToTabbarIndex:(NSInteger)index pushToTargetViewController:(UIViewController *)targetController withAnimation:(BOOL)animated comlite:(void (^)())complite;

//是否已经存在登入界面
- (BOOL)isExistModeControllerShow:(NSString *)controller;

//为tab添加红色点
- (void)addNormalRemindDot:(NSString *)dotImageName selectedDotImageName:(NSString *)selectedImageName atIndex:(NSInteger )index;
- (void)replaceRemindDotAtIndex:(NSInteger )index withNormalImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;

//获取导航栈中顶层视图
- (UIViewController *)topController;

//获取登录界面下导航控制器的顶层视图
- (UIViewController *)topControllerUnderLoginModelViewController;

//清除前一层导航
- (void)clearPreNavigationCtrl;

//获取到对应根导航控制器
- (UINavigationController *)getRootNavigationControllerAtIndex:(NSInteger)index;

//获取模态控制器的层次
- (UIViewController *)topModelRootViewController;
@end
