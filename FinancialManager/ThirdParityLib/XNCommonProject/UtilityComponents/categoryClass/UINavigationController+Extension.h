//
//  UINavigationController+Extension.h
//  FinancialManager
//
//  Created by xnkj on 15/10/10.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationController(Extension)

@property (strong, nonatomic) UIColor *currentNaviBackgroundColor;
@property (strong, nonatomic) UIImageView *navigationBackground;

- (void)setNavigationBarAttributes:(BOOL)translucent;

- (void)setNavigationBarAttributesWithImage:(BOOL)bImage translucent:(BOOL)translucent;

//设置导航栏背景颜色和是否透明
- (void)setNavigationAttributeWithColor:(UIColor *)color translucent:(BOOL)translucent;

//设置导航栏背景图片和是否透明
- (void)setNavigationAttributeWithUIImage:(UIImage *)image translucent:(BOOL)translucent;

//设置导航条颜色
- (void)changeNavigationBarTintColorWithoutBottomLine:(UIColor *)color;

//移除导航条颜色
- (void)removeCurrentNavigationBackground;

@end
