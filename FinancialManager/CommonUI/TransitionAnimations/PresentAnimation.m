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
    //动画执行的时间
    return 0.3f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect finalPosition = [transitionContext finalFrameForViewController:toVC];
    CGRect finalFromVCPosition = CGRectMake(-fromVc.view.width * 0.25, fromVc.view.top, fromVc.view.width, fromVc.view.height);
    toVC.view.frame = CGRectOffset(finalPosition, bounds.size.width, 0);
    
    UIView *containerView= [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromVc.view.frame = finalFromVCPosition;
                         toVC.view.frame = finalPosition;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];

}


@end
