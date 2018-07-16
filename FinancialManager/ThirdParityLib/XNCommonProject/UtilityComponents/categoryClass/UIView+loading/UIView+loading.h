//
//  UIView+loading.h
//  FinancialManager
//
//  Created by xnkj on 15/10/16.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completeBlock)();

@interface UIView(loading)

- (void)showLoading;
- (void)showLoadingForTitle:(NSString *)title;
- (void)hideLoading;

- (void)showGifLoading;
- (void)showSpecialGifLoading;

- (void)showCustomWarnViewWithContent:(NSString *)content;
- (void)showCustomWarnViewWithContent:(NSString *)content Completed:(completeBlock)completed;

- (void)showCustomAlertView:(NSString *)contentString image:(NSString *)imageString;
- (void)showCustomAlertView:(NSString *)content image:(NSString *)imageString Completed:(completeBlock)completed;
@end
