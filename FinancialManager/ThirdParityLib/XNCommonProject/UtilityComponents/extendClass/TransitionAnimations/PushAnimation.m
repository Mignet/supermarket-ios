//
//  PresentAnimation.m
//  JinFuZiApp
//
//  Created by Galvin on 15/5/18.
//  Copyright (c) 2015年 Galvin. All rights reserved.
//

#import "PushAnimation.h"
#import "UIView+frame.h"
#import "UIViewController+Extend.h"

@interface PushAnimation()

@property (nonatomic, assign) BOOL navigationBarHide;
@end

@implementation PushAnimation

- (id)initNavigationStatus:(BOOL)navigationBarHide
{
    self = [super init];
    if (self) {
        
        self.navigationBarHide = navigationBarHide;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //动画执行的时间
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //往容器中添加要显示的视图
    UIView *containerView = [transitionContext containerView];
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromVC.view.frame = initialFrame;
    
    UIView * tmpView = [[[UIApplication sharedApplication] keyWindow] snapshotViewAfterScreenUpdates:NO];
    fromVC.snaptView = tmpView;
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    if (!self.navigationBarHide) {
        
        height = height - (Device_Is_iPhoneX?88:64);
    }
    toVC.view.frame = CGRectMake(0, self.navigationBarHide?0:Device_Is_iPhoneX?88:64, initialFrame.size.width, height);
    [toVC.navigationController setNavigationBarHidden:self.navigationBarHide];
    toVC.parentViewController.tabBarController.tabBar.hidden = YES;

    [containerView addSubview:toVC.view];
    if (toVC.parentViewController.parentViewController) {
        
        toVC.parentViewController.parentViewController.view.frame = CGRectOffset(CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height), [UIScreen mainScreen].bounds.size.width, 0);
    }else
    {
        toVC.parentViewController.view.frame = CGRectOffset(CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height), [UIScreen mainScreen].bounds.size.width, 0);
    }
    
    //渐变层
    UIView *shadow = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    shadow.backgroundColor = [UIColor blackColor];
    shadow.alpha = 0.0f;
    [tmpView addSubview:shadow];
    
    [[[UIApplication sharedApplication] keyWindow] insertSubview:tmpView atIndex:0];

    //开始动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        shadow.alpha = 0.6f;
//        tmpView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.98, 0.98);
        
        if (toVC.parentViewController.parentViewController) {
        
            toVC.parentViewController.parentViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }else
        {
            toVC.parentViewController.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        }
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
        tmpView.transform = CGAffineTransformIdentity;
        [tmpView removeFromSuperview];
        [shadow removeFromSuperview];

    }];
}

@end
