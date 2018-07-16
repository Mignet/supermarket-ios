//
//  MIInitPayPwdViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/13.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//
#import "MIInitPayPwdViewController.h"
#import "MIDeportMoneyController.h"

#import "XNPasswordManagerModule.h"
#import "XNPasswordManagerObserver.h"

@interface MIInitPayPwdViewController ()<PasswordViewDelegate,XNPasswordManagerObserver>

@property (nonatomic, strong) NSString               * firstPayPassword;
@property (nonatomic, strong) NSString               * confirmPayPassword;
@property (nonatomic, assign) ModifyPayPwdType         payStatus;
@end

@implementation MIInitPayPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initSubView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[XNPasswordManagerModule defaultModule] addObserver:self];
    [self.inputPwdView fieldBecomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[XNPasswordManagerModule defaultModule] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////
#pragma mark - Custome Method
///////////////////////////////////////////

#pragma makr - 初始化
- (void)initSubView
{
    self.title = @"设置交易密码";
    self.inputPwdView.delegate = self;
    self.titleLabel.text = @"请设置您的6位数字交易密码，用于提现";
    self.firstPayPassword = @"";
    self.confirmPayPassword = @"";
    self.payStatus = InputNewPayPwdStatus;
}

//////////////////////
#pragma mark - Protocal
//////////////////////////////////

#pragma mark - SetGestureDelegate
- (void)passwordView:(SetPasswordView *)passwordView inputPassword:(NSString *)password
{

    if(self.payStatus == InputNewPayPwdStatus)
    {
        self.firstPayPassword = password;
        self.payStatus = ReInputNewPayPwdStatus;
        self.titleLabel.text = @"请再次输入交易密码";
        [self.inputPwdView clearUpPassword];
    }else
    {
        [self.view endEditing:YES];
        self.confirmPayPassword = password;
        if (![self.firstPayPassword isEqualToString:self.confirmPayPassword]) {
            
            self.payStatus = InputNewPayPwdStatus;
            self.titleLabel.text = @"请设置您的6位数字交易密码，用于提现";
            [self showCustomWarnViewWithContent:@"二次密码不一致，请重新输入"];
            [self.inputPwdView clearUpPassword];
            return;
        }
        
        //开始修改支付密码
        [[XNPasswordManagerModule defaultModule] userSetPayPassword:self.firstPayPassword];
        [self.view showGifLoading];
    }
}

#pragma mark - 初始化支付密码
- (void)XNUserModuleInitPayPasswordDidReceive:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    
    NSString * ctl = [_LOGIC getValueForKey:XN_USER_INIT_PAY_PASSWORD_CONTROLLER];
    
    [_UI popViewControllerFromRoot:YES ToNavigationCtrl:ctl comlite:nil];
}

- (void)XNUserModuleInitPayPasswordDidFailed:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    [self.inputPwdView clearUpPassword];
    self.payStatus = InputNewPayPwdStatus;
    self.titleLabel.text = @"请设置您的6位数字交易密码，用于提现";
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

@end
