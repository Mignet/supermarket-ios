//
//  UIView+Common.h
//  XNCommonProject
//
//  Created by xnkj on 5/6/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView(Common)

- (UIImage *)screenSnapWithRect:(CGSize)size captureSize:(CGRect )rect;

//震动效果
- (void)shakeAnimationForDuration:(NSTimeInterval )duration;

//移除指定动画
- (void)removeShakeAnimation;
@end
