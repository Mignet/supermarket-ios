//
//  BaseViewController.h
//  FinancialManager
//
//  Created by xnkj on 15/9/17.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)keyboardShow:(NSNotification *)notif;
- (void)keyboardHide:(NSNotification *)notif;
- (void)exitKeyboard;
- (void)exitKeyboardToOtherOperation;
- (void)clickBack:(UIButton *)sender;
- (void)loginSuccessRfreshData;

@end
