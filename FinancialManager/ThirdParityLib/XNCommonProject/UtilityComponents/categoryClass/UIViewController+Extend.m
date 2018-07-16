//
//  UIViewController+Extend.m
//  FinancialManager
//
//  Created by xnkj on 15/10/10.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UIViewController+Extend.h"
#import "UINavigationBar+Background.h"
#import "UINavigationController+Extension.h"
#import "objc/runtime.h"

#define XN_VIEWCONTROLLER_HIDEN_TAG @"NAVIGATIONHIDEN"
#define XN_VIEWCONTROLLER_SNAPT_VIEW_TAG @"snaptView"
#define XN_VIEWCONTROLLER_NAVIGATIONBAR_NEW_TAG @"NAVIGATIONBAR" //是否创建新的导航条颜色
#define XN_VIEWCONTROLLER_NAVIGATIONTITLE_NEW_TAG @"NAVIGATIONTITLE" //是否创建新的导航条标题颜色
#define XN_VIEWCONTROLLER_NAVIGATIONSEPERATORSTATUS_NEW_TAG @"NAVIGATIONSEPERATORSTATUS" //导航条分割线是否存在
#define XN_VIEWCONTROLLER_SWITCHVIEWANIMATION_NEW_TAG @"SWITCHVIEWANIMATION" //切换动画
#define XN_VIEWCONTROLLER_SWITCHTOHOMEPAGE_TAG @"SWITCHTOHOMEPAGE" //切换动画
#define XN_VIEWCONTROLLER_WRAPERCLASSNAME_TAG @"XN_VIEWCONTROLLER_WRAPERCLASSNAME_TAG" //包裹的对象

@implementation UIViewController(Extend)

+(void)load
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        [UIViewController exchangeOldMethod:@"viewWillAppear:" newMethod:@"newViewWillAppear:"];
        [UIViewController exchangeOldMethod:@"layoutSubviews" newMethod:@"newLayoutSubviews"];
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

#pragma mark - newViewWillAppear
- (void)newViewWillAppear:(BOOL)animated
{
    UIColor * barColor = self.newNavigationBarColor;
    UIColor * titleColor = self.newNavigationTitleColor;
    BOOL navigationSeperatorStatus = self.navigationSeperatorLineStatus;
    if (!barColor) {
        
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self.navigationController.navigationBar resetNavigationBar];
        [self.navigationController setNavigationAttributeWithUIImage:[UIImage imageNamed:@"menu_bar_bg.png"] translucent:NO];
    }else
    {
        [self.navigationController.navigationBar resetNavigationBar];
        [self.navigationController.navigationBar setNavigationBarBgColor:barColor];
        
        if (titleColor) {
            
            [self.navigationController.navigationBar setTitleTextAttributes:
             @{NSForegroundColorAttributeName:titleColor}];
        }
    }
    
    if (navigationSeperatorStatus)
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    
    [self newViewWillAppear:animated];
}

- (void)setCustomNavigationBarHide:(BOOL)hide
{
    objc_setAssociatedObject(self, XN_VIEWCONTROLLER_HIDEN_TAG,[NSNumber numberWithBool:hide] , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)customNavigationBarHide
{
    return [objc_getAssociatedObject(self, XN_VIEWCONTROLLER_HIDEN_TAG) boolValue];
}

- (void)setSnaptView:(UIView *)snaptView
{
    objc_setAssociatedObject(self, XN_VIEWCONTROLLER_SNAPT_VIEW_TAG,snaptView , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)snaptView
{
    return objc_getAssociatedObject(self, XN_VIEWCONTROLLER_SNAPT_VIEW_TAG);
}

- (void)setNewNavigationBarColor:(UIColor *)newColor
{
    
    objc_setAssociatedObject(self, XN_VIEWCONTROLLER_NAVIGATIONBAR_NEW_TAG,newColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)newNavigationBarColor
{
    UIColor * color = objc_getAssociatedObject(self, XN_VIEWCONTROLLER_NAVIGATIONBAR_NEW_TAG);
    
    return color;
}

- (void)setNewNavigationTitleColor:(UIColor *)newColor
{
    
    objc_setAssociatedObject(self, XN_VIEWCONTROLLER_NAVIGATIONTITLE_NEW_TAG,newColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)newNavigationTitleColor
{
    UIColor * color = objc_getAssociatedObject(self, XN_VIEWCONTROLLER_NAVIGATIONTITLE_NEW_TAG);
    
    return color;
}

- (void)setNavigationSeperatorLineStatus:(BOOL)status
{
    
    objc_setAssociatedObject(self, XN_VIEWCONTROLLER_NAVIGATIONSEPERATORSTATUS_NEW_TAG,[NSNumber numberWithBool:status], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)navigationSeperatorLineStatus
{
    BOOL status = [objc_getAssociatedObject(self, XN_VIEWCONTROLLER_NAVIGATIONSEPERATORSTATUS_NEW_TAG) boolValue];
    
    return status;
}

- (void)setNeedNewSwitchViewAnimation:(BOOL)status
{
    objc_setAssociatedObject(self, XN_VIEWCONTROLLER_SWITCHVIEWANIMATION_NEW_TAG,[NSNumber numberWithBool:status], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)needNewSwitchViewAnimation
{
    BOOL status = [objc_getAssociatedObject(self, XN_VIEWCONTROLLER_SWITCHVIEWANIMATION_NEW_TAG) boolValue];
    
    return status;
}

- (void)setWraperClassName:(NSString *)wraperClassName
{
    objc_setAssociatedObject(self, XN_VIEWCONTROLLER_WRAPERCLASSNAME_TAG,wraperClassName, OBJC_ASSOCIATION_COPY);
}

- (NSString *)wraperClassName
{
    NSString * wraperClassName = objc_getAssociatedObject(self, XN_VIEWCONTROLLER_WRAPERCLASSNAME_TAG);
    
    return wraperClassName;
}

- (void)setSwitchToHomePage:(BOOL)status
{
    
    objc_setAssociatedObject(self, XN_VIEWCONTROLLER_SWITCHTOHOMEPAGE_TAG,[NSNumber numberWithBool:status], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)switchToHomePage
{
    BOOL status = [objc_getAssociatedObject(self, XN_VIEWCONTROLLER_SWITCHTOHOMEPAGE_TAG) boolValue];
    
    return status;
}
@end
