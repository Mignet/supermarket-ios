//
//  SetPasswordView.h
//  demo
//
//  Created by xnkj on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PasswordView;

@protocol PasswordViewDelegate <NSObject>

@optional

- (void)passwordView:(PasswordView*)passwordView inputPassword:(NSString*)password;
- (void)passwordInputControllerDidForgetPassword;
@end

@interface PasswordView : UIView

@property (nonatomic, strong) UITextField    * passwordTextField;
@property (nonatomic, weak) id<PasswordViewDelegate> delegate;


- (void)setDotWithCount:(NSInteger)count;
- (void)clearUpPassword;
- (void)finishedInput;
- (void)fieldBecomeFirstResponder;
@end
