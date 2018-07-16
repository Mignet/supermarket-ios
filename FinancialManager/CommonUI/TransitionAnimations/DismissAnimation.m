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
    fromVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    fromVC.view.layer.shadowOffset = CGSizeMake(-4, 0);
    fromVC.view.layer.shadowRadius = 4;
    fromVC.view.layer.shadowOpacity = 0.3;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    
    CGRect finalPosititon = CGRectOffset(initialFrame, bounds.size.width, 0);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView sendSubviewToBack:toVC.view];
    toVC.view.frame = CGRectMake(-toVC.view.frame.size.width*0.3, toVC.view.frame.origin.y, toVC.view.frame.size.width, toVC.view.frame.size.height);
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                     animations:^{
                         toVC.view.frame = initialFrame;
                         fromVC.view.frame = finalPosititon;
                         fromVC.view.layer.shadowOpacity = 0;
    }
                     completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end
