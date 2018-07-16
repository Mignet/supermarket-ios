//
//  DismissAnimation.m
//  JinFuZiApp
//
//  Created by Galvin on 15/5/18.
//  Copyright (c) 2015年 Galvin. All rights reserved.
//

#import "PopAnimation.h"
#import "UIViewController+Extend.h"

@interface PopAnimation()

@property (nonatomic, assign) BOOL navigationBarHide;
@property (nonatomic, assign) BOOL tabBarStatus;
@end

@implementation PopAnimation

- (id)initNavigationStatus:(BOOL)navigationBarStatus tabBarStatus:(BOOL)tabBarStatus;
{
    self = [super init];
    if (self) {
        
        self.navigationBarHide = navigationBarStatus;
        self.tabBarStatus = tabBarStatus;
    }
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL currentNavigationStatus = fromVC.customNavigationBarHide;
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navigationBarHeight = _UI.tabBarNaviCtrl.navigationBar.frame.size.height <= 0?44:_UI.tabBarNaviCtrl.navigationBar.frame.size.height;

    //往容器中添加要显示的视图
    UIView *containerView = [transitionContext containerView];

    __block CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [containerView setFrame:CGRectMake(0, 0, width, height)];
    [containerView setBackgroundColor:[UIColor blackColor]];
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    currentNavigationStatus = fromVC.customNavigationBarHide;
    
    fromVC.view.frame = CGRectMake(0, 0, width, height);
    
    if (!currentNavigationStatus) {
        
        [fromVC.navigationController.navigationBar setTop:- (navigationBarHeight + statusHeight)];
    }
//    [fromVC.navigationController setNavigationBarHidden:YES];//不要频繁使用此导致导航条错乱
    fromVC.parentViewController.tabBarController.tabBar.hidden = YES;
    
    toVC.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
//    toVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.98, 0.98);
    [containerView insertSubview:toVC.view atIndex:0];

    __block UIView * tmpView = toVC.snaptView;
   
    [toVC.view addSubview:tmpView];
    
    __block UIView * tmpCurrentView = [[[UIApplication sharedApplication] keyWindow] snapshotViewAfterScreenUpdates:NO];
    [fromVC.view addSubview:tmpCurrentView];
    
    UIView *shadow = [[UIView alloc]initWithFrame:tmpView.frame];
    shadow.backgroundColor = [UIColor blackColor];
    shadow.alpha = 0.6f;
    [tmpView addSubview:shadow];
    
    //开始动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        shadow.alpha = 0.0f;
        toVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        fromVC.view.frame = CGRectOffset(CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height), [UIScreen mainScreen].bounds.size.width, 0);
        
    } completion:^(BOOL finished) {
    
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
        if (transitionContext.transitionWasCancelled) {
            
            fromVC.view.frame = initialFrame;
            
            if (!currentNavigationStatus) {
                
                [fromVC.navigationController.navigationBar setTop:statusHeight];
            }
        }else
        {
            if (!self.navigationBarHide) {
                
                height = height - (Device_Is_iPhoneX?88:64);
            }
            
            toVC.view.frame = CGRectMake(0, self.navigationBarHide?0:(Device_Is_iPhoneX?88:64), [UIScreen mainScreen].bounds.size.width, height);
            [toVC.navigationController.navigationBar setTop:statusHeight];
            [toVC.navigationController setNavigationBarHidden:self.navigationBarHide];
            toVC.parentViewController.tabBarController.tabBar.hidden = self.tabBarStatus;
        }
        
        toVC.view.transform = CGAffineTransformIdentity;
        
        [tmpCurrentView removeFromSuperview];
        [shadow removeFromSuperview];
        
        [tmpView removeFromSuperview];
        tmpView = nil;
        
        tmpCurrentView = nil;
    }];
}

@end
