//
//  XNLoadFailedController.h
//  FinancialManager
//
//  Created by xnkj on 15/10/28.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(XNLoadFailedController)

//加载中
- (void)showLoadingTarget:(id)target withTitle:(NSString *)title;

//指定页面网络加载失败
- (void)showNetworkLoadingFailedDidReloadTarget:(id)target Action:(SEL)action;
- (BOOL)isExistNetworkLoadingFailedTarget:(id)target;
- (void)hideLoadingTarget:(id)target;
@end
