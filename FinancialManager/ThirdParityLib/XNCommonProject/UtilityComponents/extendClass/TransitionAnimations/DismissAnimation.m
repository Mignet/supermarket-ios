//
//  DismissAnimation.m
//  JinFuZiApp
//
//  Created by Galvin on 15/5/18.
//  Copyright (c) 2015年 Galvin. All rights reserved.
//

#import "DismissAnimation.h"

@implementation DismissAnimation

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //往容器中添加要显示的视图
    UIView *containerView = [transitionContext containerView];
    CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
    
    [containerView insertSubview:toVC.view atIndex:0];
    
    UIView * tmpView = toVC.snaptView;
    if (tmpView)
       [containerView insertSubview:tmpView aboveSubview:toVC.view];
    
    //开始动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromVC.view.frame = CGRectOffset(initFrame, 0, SCREEN_FRAME.size.height);
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
        if (tmpView)
           [tmpView removeFromSuperview];
    }];
}

@end
