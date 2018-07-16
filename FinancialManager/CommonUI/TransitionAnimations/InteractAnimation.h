//
//  InteractAnimation.h
//  JinFuZiApp
//
//  Created by Galvin on 15/5/18.
//  Copyright (c) 2015年 Galvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractAnimation : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;
@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic, weak) UIViewController *presentingVC;
@property (nonatomic, weak) UIViewController *parentVC;

-(void)wireToViewController:(UIViewController *)viewController andParentVC:(UIViewController *)parentVC;

@end
