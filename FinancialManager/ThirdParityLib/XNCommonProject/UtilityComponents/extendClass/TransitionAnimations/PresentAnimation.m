//
//  PresentAnimation.m
//  JinFuZiApp
//
//  Created by Galvin on 15/5/18.
//  Copyright (c) 2015年 Galvin. All rights reserved.
//

#import "PresentAnimation.h"

@implementation PresentAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //往容器中添加要显示的视图
    UIView *containerView = [transitionContext containerView];
    
    UIView * tmpView = fromVC.snaptView;
    if (!tmpView) {
        
        tmpView = [[[[UIApplication sharedApplication] keyWindow] snapshotViewAfterScreenUpdates:NO] snapshotViewAfterScreenUpdates:NO];
        fromVC.snaptView = tmpView;
    }
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    toVC.view.frame = CGRectOffset(initialFrame, 0, SCREEN_FRAME.size.height);
    [containerView addSubview:toVC.view];
    [containerView insertSubview:tmpView aboveSubview:fromVC.view];
    
    //开始动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        toVC.view.frame = CGRectOffset(toVC.view.frame, 0, -SCREEN_FRAME.size.height);
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        
        if (tmpView)
        [tmpView removeFromSuperview];
    }];
}


@end
