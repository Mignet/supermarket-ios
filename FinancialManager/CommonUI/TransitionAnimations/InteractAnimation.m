//
//  InteractAnimation.m
//  JinFuZiApp
//
//
//  Created by Galvin on 15/5/18.
//  Copyright (c) 2015年 Galvin. All rights reserved.
//

#import "InteractAnimation.h"

@implementation InteractAnimation

-(void)wireToViewController:(UIViewController *)viewController andParentVC:(UIViewController *)parentVC
{
    
    self.presentingVC = viewController;
    self.parentVC = parentVC;
    [self prepareGestureRecognizerInView:viewController.view];
}

- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}

-(CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
           //开始滑动
            self.interacting = YES;
            [self.parentVC dismissViewControllerAnimated:YES completion:nil];
            JCLogInfo(@"begin gesture");
            break;
        case UIGestureRecognizerStateChanged: {
            //根据滑动的point计算位置百分比
            CGFloat progress = (translation.x / SCREEN_FRAME.size.width)  ;
            progress = MIN(1.0, MAX(0.0, progress));
            self.presentingVC.view.layer.shadowOpacity = (0.3 - progress *0.3);
            self.shouldComplete = (progress > 0.3);
            [self updateInteractiveTransition:progress];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            //结束来判断是否dissmiss
            self.interacting = NO;
            if (!self.shouldComplete || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

@end
