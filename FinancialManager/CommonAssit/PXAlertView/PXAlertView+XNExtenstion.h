//
//  PXAlertView+XNExtenstion.h
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/20/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "PXAlertView.h"

@interface PXAlertView  (XNExtenstion)

+ (instancetype)xn_showAlertWithTitle:(NSString *)title
                              message:(NSString *)message
                          cancelTitle:(NSString *)cancelTitle
                           otherTitle:(NSString *)otherTitle
                           completion:(PXAlertViewCompletionBlock)completion;

@end
