//
//  UINavigationBar+Background.m
//  FinancialManager
//
//  Created by xnkj on 27/06/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "UINavigationBar+Background.h"

#define overlayTag @"overlayTag"

@implementation UINavigationBar(Background)

+(void)load
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        [UINavigationBar exchangeOldMethod:@"layoutSubviews" newMethod:@"newLayoutSubviews"];
    });
}

+ (void)exchangeOldMethod:(NSString *)oldMethodName newMethod:(NSString *)newMehthodName
{
    SEL newSelector = NSSelectorFromString(newMehthodName);
    SEL oldSelector = NSSelectorFromString(oldMethodName);
    
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    Method oldMethod    = class_getInstanceMethod([self class],oldSelector);
    
    BOOL addSuccess = class_addMethod([self class], newSelector, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
    if (addSuccess)
    {
        class_replaceMethod([self class], oldSelector, method_getImplementation(newMethod), method_getTypeEncoding(oldMethod));
    }else
    {
        method_exchangeImplementations(oldMethod, newMethod);
    }
}

//刷新试图
- (void)newLayoutSubviews
{
    [self newLayoutSubviews];
    
    if (self.overlay) {
        
        NSInteger index = [self.subviews indexOfObject:self.overlay];
        if (index != 0) {
            [self exchangeSubviewAtIndex:0 withSubviewAtIndex:index];
        }
    }
}

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, overlayTag);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, overlayTag, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNavigationBarBgWithImage:(UIImage *)bgImage
{
    [self setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

- (void)setNavigationBarBgColor:(UIColor *)bgColor
{
    if (!self.overlay) {
       
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -44, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 44)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:1];
        self.translucent = YES;
    }
    
    self.overlay.backgroundColor = bgColor;
}

- (void)resetNavigationBar
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

@end
