//
//  UIView+animation.m
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import "UIView+animation.h"

@implementation UIView (animation)

-(void)applyFadeAnimationWithKey:(NSString*)key
{
    if (self == nil) {
        return ;
    }
    [self applyFadeAnimationWithKey:key duration:0.3f];
    
}

-(void)removeFadeAnimationWithKey:(NSString*)key
{
    if (self == nil) {
        return ;
    }
    [self.layer removeAnimationForKey:key];
}

-(void)applyFadeAnimationWithKey:(NSString*)key duration:(CGFloat)duration
{
    if (self == nil) {
        return ;
    }
    
    // 下面实现的是淡入的动画效果
    CATransition *animation = [CATransition animation];
    [animation setDuration:duration];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setType:kCATransitionFade];
    
    [self.layer removeAnimationForKey:key];
    [self.layer addAnimation:animation forKey:key];
}

@end
