//
//  UINavigationController+Extension.m
//  FinancialManager
//
//  Created by xnkj on 15/10/10.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UINavigationController+Extension.h"
#import "UIImage+Common.h"
#import "objc/runtime.h"

const char * const NaviColor = "xnapp.navigationbar.color";
const char * const NaviImageView = "xnapp.navigationbar.imageView";

@implementation UINavigationController(Extension)

- (void)setNavigationBarAttributes:(BOOL)translucent
{
    UIColor * cc = [AppFramework getConfig].navBgTitleColor;
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f],UITextAttributeFont, cc, UITextAttributeTextColor, nil];
    self.navigationBar.titleTextAttributes = dict;
    self.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationBar.translucent = translucent;
}

- (void)setNavigationBarAttributesWithImage:(BOOL)bImage translucent:(BOOL)translucent {
    UIColor * cc = [AppFramework getConfig].navBgTitleColor;//[UIColor colorWithRed:61/255.0 green:66/255.0 blue:69/255.0 alpha:1.0];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f],UITextAttributeFont, cc, UITextAttributeTextColor, nil];
    self.navigationBar.titleTextAttributes = dict;
    
    UIColor *color;
    if (bImage) {
        [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        color = [AppFramework getConfig].navBgColor;
        if (IOS7_OR_LATER) {
            self.navigationBar.barTintColor = color;
        }
        else{
            self.navigationBar.tintColor = color;
        }
    }
    else {
        //color = [UIColor UIColorFromRGB:0x3d4245 alpha:.9];
        color = UIColorFromHex(0xef490f);
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:color andSize:CGSizeMake(320, 64)] forBarMetrics:UIBarMetricsDefault];
        if ([self.navigationBar respondsToSelector:@selector(shadowImage)]) {
            self.navigationBar.shadowImage = [UIImage imageWithColor:color andSize:CGSizeMake(320, 1)];
        }
    }
    
    self.navigationBar.translucent = translucent;
}


#pragma mark - 设置导航栏背景颜色和是否透明
- (void)setNavigationAttributeWithColor:(UIColor *)color translucent:(BOOL)translucent
{
    UIColor * cc = [AppFramework getConfig].navBgTitleColor;
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f],NSFontAttributeName, cc, NSForegroundColorAttributeName, nil];
    self.navigationBar.titleTextAttributes = dict;

    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:color andSize:CGSizeMake(320, 64)] forBarMetrics:UIBarMetricsDefault];
    if ([self.navigationBar respondsToSelector:@selector(shadowImage)]) {
            self.navigationBar.shadowImage = [UIImage imageWithColor:color andSize:CGSizeMake(320, 1)];
    }
    
    self.navigationBar.translucent = translucent;
}

#pragma mark - 设置导航栏背景图片和是否透明
- (void)setNavigationAttributeWithUIImage:(UIImage *)image translucent:(BOOL)translucent
{
    UIColor * cc = [AppFramework getConfig].navBgTitleColor;
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f],NSFontAttributeName, cc, NSForegroundColorAttributeName, nil];
    self.navigationBar.titleTextAttributes = dict;
    
    UIColor *color;
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    color = [AppFramework getConfig].navBgColor;
    if (IOS7_OR_LATER) {
        self.navigationBar.barTintColor = color;
    }
    else{
        self.navigationBar.tintColor = color;
    }

    self.navigationBar.translucent = translucent;
}

-(void)setCurrentNaviBackgroundColor:(UIColor *)currentNaviBackgroundColor
{
    if(self.currentNaviBackgroundColor != currentNaviBackgroundColor){
        objc_setAssociatedObject(self, NaviColor, currentNaviBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

-(UIColor *)currentNaviBackgroundColor
{
    UIColor *existingColor = objc_getAssociatedObject(self, NaviColor);
    if(existingColor) {
        return existingColor;
    }
    UIColor *naviColor = [AppFramework getConfig].navBgColor;
    objc_setAssociatedObject(self, NaviColor, naviColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return naviColor;
}

- (UIImageView *)navigationBackground
{
    UIImageView *existingImageView = objc_getAssociatedObject(self, NaviImageView);
    if(existingImageView) {
        return existingImageView;
    }
    
    UIImageView *naviImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, -20, self.navigationBar.width, self.navigationBar.height+20)];
    objc_setAssociatedObject(self, NaviImageView, naviImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return naviImageView;
}

- (void)changeNavigationBarTintColorWithoutBottomLine:(UIColor *)color
{
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                imageView.hidden = YES;
            }
        }
    }
//    if(self.currentNaviBackgroundColor != color){
//        self.currentNaviBackgroundColor = color;
//        self.navigationBackground.image = [UIImage imageWithColor:color andSize:CGSizeMake(self.navigationBackground.width, self.navigationBackground.height)];
//    }
//    [self.navigationBar insertSubview:self.navigationBackground atIndex:0];
    
}

- (void)removeCurrentNavigationBackground
{
    [self.navigationBackground removeFromSuperview];
    if ([self.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                imageView.hidden = NO;
            }
        }
    }
}



@end
