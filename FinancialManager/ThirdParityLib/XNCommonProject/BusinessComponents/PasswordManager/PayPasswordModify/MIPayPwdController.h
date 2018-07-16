//
//  MIPayPwdController.h
//  FinancialManager
//
//  Created by xnkj on 15/10/13.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"
#import "SetPasswordView.h"

typedef NS_ENUM(NSInteger, ModifyPayPwdType){
    
    VerifyOldPayPwdStatus = 0,
    InputNewPayPwdStatus,
    ReInputNewPayPwdStatus,
    IModifyPayPwdMax
};

@interface MIPayPwdController : BaseViewController

@property (nonatomic, strong) UILabel                * titleLabel;
@property (nonatomic, strong) SetPasswordView        *  inputPwdView;

@end
