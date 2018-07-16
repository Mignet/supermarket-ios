//
//  UIView+Common.m
//  XNCommonProject
//
//  Created by xnkj on 5/6/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import "UIView+Common.h"
#import "objc/runtime.h"

#define TIMER @"TIMER"

@implementation UIView(Common)

#pragma mark - 获取屏幕指定位置的图片
- (UIImage *)screenSnapWithRect:(CGSize)size captureSize:(CGRect )rect
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIRectClip(rect);
    
    [self.layer renderInContext:context];
    
    UIImage * tmpImage = UIGraphicsGetImageFromCurrentImageContext()
    ;
    UIGraphicsEndImageContext();
    
    return tmpImage;
}

//震动效果
- (void)shakeAnimationForDuration:(NSTimeInterval )duration
{
    NSTimer * timer = objc_getAssociatedObject(self, TIMER);
    if (!timer) {

        NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(exectAnimation) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        objc_setAssociatedObject(self, TIMER, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [timer setFireDate:[NSDate distantPast]];
    }
}

//执行动画
- (void)exectAnimation
{
    [self.layer removeAnimationForKey:@"rotation"];
    
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI),@(10 /180.0 * M_PI)];
    
    keyAnimaion.removedOnCompletion = YES;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.5f;
    keyAnimaion.repeatCount = 1;
    [self.layer addAnimation:keyAnimaion forKey:@"rotation"];
}

//移除指定动画
- (void)removeShakeAnimation
{
    [self.layer removeAnimationForKey:@"rotation"];
    
    NSTimer * timer = objc_getAssociatedObject(self, TIMER);
    if (timer) {
        
        [timer invalidate];
        timer = nil;
    }
}
@end
