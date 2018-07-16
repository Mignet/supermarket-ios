//
//  UIView+animation.h
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock)();

@interface UIView (animation)

-(void)applyFadeAnimationWithKey:(NSString*)key;
-(void)applyFadeAnimationWithKey:(NSString*)key duration:(CGFloat)duration;
-(void)removeFadeAnimationWithKey:(NSString*)key;

@end
