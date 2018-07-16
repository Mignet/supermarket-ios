//
//  GXQNavigationController.h
//  GXQApp
//
//  Created by 振增 黄 on 14-6-19.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GXQNavigationControllerDelegate <NSObject>
@optional
- (id)GXQNavigationControllerSupportedInteractivePopGestureRecognizer;
@end

@interface GXQNavigationController : UINavigationController

- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;
@end
