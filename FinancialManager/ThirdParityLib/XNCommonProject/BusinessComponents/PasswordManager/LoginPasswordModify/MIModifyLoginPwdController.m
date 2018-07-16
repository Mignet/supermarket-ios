//
//  MIModifyLoginPwdController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/13.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIModifyLoginPwdController.h"

#import "UserForgetPasswordController.h"

#import "XNPasswordManagerModule.h"
#import "XNPasswordManagerObserver.h"

@interface MIModifyLoginPwdController ()

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, weak) IBOutlet UITextField * oldPwdTextField;
@property (nonatomic, weak) IBOutlet UITextField * firstPwdTextField;
@property (nonatomic, weak) IBOutlet UITextField * confirmTextField;
@end

@implementation MIModifyLoginPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.oldPwdTextField becomeFirstResponder];
    
    [[XNPasswordManagerModule defaultModule] addObserver:self];
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

//////////////////
#pragma mark - Custom Method
///////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"修改登录密码";
    
    [self.view addGestureRecognizer:self.tapGesture];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 用户登入
- (IBAction)loginAction:(id)sender
{
    [self.view endEditing:YES];
    if ([self.oldPwdTextField.text isEqualToString:@""]) {
        
        [self showCustomWarnViewWithContent:XNModifyLoginPasswordOldPasswordEmpty];
        return;
    }
    
    if ([self.firstPwdTextField.text isEqualToString:@""]) {
        
        [self showCustomWarnViewWithContent:XNRegisterInputPasswordEmpty];
    }
    
    if (![self.firstPwdTextField.text isValidatePassword]) {
        
        [self showCustomWarnViewWithContent:XNInputPasswordFormatError];
        return;
    }
    
    if (![self.firstPwdTextField.text isEqualToString:self.confirmTextField.text]) {
        
        [self showCustomWarnViewWithContent:XNRegisterTwoInputPasswordUnSame];
        return;
    }

    //开始进行网络请求
    [[XNPasswordManagerModule defaultModule] userModifyLoginPassword:self.oldPwdTextField.text NewPwd:self.firstPwdTextField.text];
    [self.view showGifLoading];
}

#pragma mark - 忘记密码
- (IBAction)forgetPasswordAction:(id)sender
{
    UserForgetPasswordController * forgetCtrl = [[UserForgetPasswordController alloc]initWithNibName:@"UserForgetPasswordController" bundle:nil hideNavigationStatus:NO];
    
    [_UI pushViewControllerFromRoot:forgetCtrl animated:YES];
}

#pragma mark - 退出键盘
- (void)exitKeyboard:(UIGestureRecognizer *)gesture
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

//////////////////////
#pragma mark - Protocol
///////////////////////////////////

#pragma mark - XNUserModuleObserver
- (void)XNUserModuleModifyLoginPasswordDidReceive:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    
    [_KEY_WINDOW showCustomWarnViewWithContent:@"成功修改登录密码" Completed:^(){
        
       [_UI popViewControllerFromRoot:YES];
    }];
}

- (void)XNUserModuleModifyLoginPasswordDidFailed:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//////////////////////
#pragma mark - setter/getter
///////////////////////////////////

#pragma mark - tapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitKeyboard:)];
    }
    return _tapGesture;
}

@end
