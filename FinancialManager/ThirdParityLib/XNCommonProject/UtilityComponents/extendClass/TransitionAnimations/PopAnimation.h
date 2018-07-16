//
//  DismissAnimation.h
//  JinFuZiApp
//
//  Created by Galvin on 15/5/18.
//  Copyright (c) 2015年 Galvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopAnimation : NSObject<UIViewControllerAnimatedTransitioning>

- (id)initNavigationStatus:(BOOL)navigationBarStatus tabBarStatus:(BOOL)tabBarStatus;
@end
