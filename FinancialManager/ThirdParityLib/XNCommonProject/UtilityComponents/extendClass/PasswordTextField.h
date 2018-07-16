//
//  PasswordTextField.h
//  Lhlc
//
//  Created by ancye.Xie on 2/16/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordTextField : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *hideLabel;
@property (nonatomic, assign) BOOL isShowPassword;

@end
