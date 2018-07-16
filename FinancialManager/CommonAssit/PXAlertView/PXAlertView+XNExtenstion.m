//
//  PXAlertView+XNExtenstion.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/20/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "PXAlertView+XNExtenstion.h"
#import "PXAlertView+Customization.h"
#import "UIColor+XNUtil.h"

@implementation PXAlertView (XNExtenstion)

+ (instancetype)xn_showAlertWithTitle:(NSString *)title
                              message:(NSString *)message
                          cancelTitle:(NSString *)cancelTitle
                           otherTitle:(NSString *)otherTitle
                           completion:(PXAlertViewCompletionBlock)completion {
    
    PXAlertView *alertView = [self showAlertWithTitle:title
                                              message:message
                                          cancelTitle:cancelTitle
                                           otherTitle:otherTitle
                                           completion:completion];
    [alertView useDefaultIOS7Style];
    [alertView setAllButtonsBackgroundColor:[UIColor colorWithR:214 G:87 B:81 A:1]];
    [alertView setAllButtonsNonSelectedBackgroundColor:[UIColor colorWithR:214 G:87 B:81 A:1]];
    [alertView setAllButtonsTextColor:[UIColor whiteColor]];
    [alertView setTitleColor:[UIColor blackColor]];
    [alertView setTitleFont:[UIFont boldSystemFontOfSize:16.f]];
    [alertView setMessageFont:[UIFont systemFontOfSize:15.f]];
    [alertView setMessageColor:[UIColor darkGrayColor]];
    return alertView;
}

@end