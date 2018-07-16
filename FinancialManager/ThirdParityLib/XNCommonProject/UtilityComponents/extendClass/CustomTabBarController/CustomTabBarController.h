//
//  GXQTabBarController.h
//  GXQApp
//
//  Created by xnkj on 16-9-17.
//  Copyright (c) 2016年 lhkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarController : UITabBarController

//添加控制器和移除控制器
- (NSInteger)addViewController:(UIViewController*)ctrl
                 imgUnselected:(NSString*)imgUnselected
                   imgSelected:(NSString*)imgSelected;
- (void)removeViewController:(UIViewController*)ctrl;

//指定的项中添加点的操作
- (void)addNormalDotImageName:(NSString *)imageName selectedDotImageName:(NSString *)selectedImageName atIndex:(NSInteger )index;
- (void)replaceRemindDotAtIndex:(NSInteger )index withNormalImageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;

//启动更新tabbar显示
- (void)refreshView;
@end
