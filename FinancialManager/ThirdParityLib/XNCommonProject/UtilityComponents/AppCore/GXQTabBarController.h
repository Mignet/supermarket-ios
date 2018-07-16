//
//  GXQTabBarController.h
//  GXQApp
//
//  Created by jinfuzi on 14-2-24.
//  Copyright (c) 2014年 jinfuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (Harmony)
- (void)setTitle:(NSString *)title;
- (void)setImage:(UIImage *)image;
@end

@interface GXQTabBar : UITabBar
{
    UIImage* imgBK;
}

+ (UITabBarController*)createControllerForMe;

@end

@interface GXQTabBarController : UITabBarController

@property (strong, nonatomic) UILabel* sampleLabel;
@property (strong, nonatomic) UILabel* sampleLabelSelected;

- (NSInteger)addViewController:(UIViewController*)ctrl
                 imgUnselected:(NSString*)imgUnselected
                   imgSelected:(NSString*)imgSelected;

- (void)removeViewController:(UIViewController*)ctrl;

- (void)setViewController:(UIViewController*)ctrl
            imgUnselected:(NSString*)imgUnselected
              imgSelected:(NSString*)imgSelected;

- (UIView*)getItemView:(NSInteger)index;

- (void)addRemindDot:(NSString *)dotImageName atIndex:(NSInteger )index;
- (void)removeRemindDotAtIndex:(NSInteger )index;

- (void)refreshView;

@end