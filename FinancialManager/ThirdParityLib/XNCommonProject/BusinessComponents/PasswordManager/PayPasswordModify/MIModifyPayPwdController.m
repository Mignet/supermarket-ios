//
//  MIModifyPayPwdController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/13.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIModifyPayPwdController.h"

#import "MIResetPayPwdController.h"

#import "XNPasswordManagerModule.h"
#import "XNUserVerifyPayPwdMode.h"
#import "XNPasswordManagerObserver.h"

@interface MIModifyPayPwdController ()<PasswordViewDelegate,XNPasswordManagerObserver>

@property (nonatomic, strong) UIButton               * forgetPwdBtn;
@property (nonatomic, strong) NSString               * oldPayPassword;
@property (nonatomic, strong) NSString               * firstPayPassword;
@property (nonatomic, strong) NSString               * confirmPayPassword;
@property (nonatomic, assign) ModifyPayPwdType payStatus;
@end

@implementation MIModifyPayPwdController

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
    self.title = @"修改交易密码";
    self.inputPwdView.delegate = self;
    self.titleLabel.text = @"修改密码前需验证原密码，请输入";
    self.payStatus = VerifyOldPayPwdStatus;
    self.oldPayPassword = @"";
    self.firstPayPassword = @"";
    self.confirmPayPassword = @"";
    
    [self.view addSubview:self.forgetPwdBtn];
    
    weakSelf(weakSelf)
    __weak SetPasswordView * tmpView = self.inputPwdView;
    [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.mas_equalTo(weakSelf.view.mas_trailing).offset(- 12);
        make.top.mas_equalTo(tmpView.mas_bottom).offset(24);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(21);
    }];
}

#pragma mark - 忘记密码
- (void)clickForgetPassword:(UIButton*)sender
{
    MIResetPayPwdController * resetPayPwdCtrl = [[MIResetPayPwdController alloc]initWithNibName:@"MIResetPayPwdController" bundle:nil];
    
    [_UI pushViewControllerFromRoot:resetPayPwdCtrl animated:YES];
}

//////////////////////
#pragma mark - Protocal
//////////////////////////////////

#pragma mark - SetGestureDelegate
- (void)passwordView:(SetPasswordView *)passwordView inputPassword:(NSString *)password
{
    if (self.payStatus == VerifyOldPayPwdStatus)
    {
        self.oldPayPassword = password;
        [[XNPasswordManagerModule defaultModule] userVerifyPayPassword:password];
        [self.view showGifLoading];
    }else if(self.payStatus == InputNewPayPwdStatus)
    {
        self.firstPayPassword = password;
        self.payStatus = ReInputNewPayPwdStatus;
        self.titleLabel.text = @"请再次输入新的交易密码";
        [self.inputPwdView clearUpPassword];
    }else
    {
        [self.view endEditing:YES];
        self.confirmPayPassword = password;
        if (![self.firstPayPassword isEqualToString:self.confirmPayPassword]) {
            
            self.payStatus = InputNewPayPwdStatus;
            self.titleLabel.text = @"请设置新的交易密码";
            [self showCustomWarnViewWithContent:@"二次密码不一致，请重新输入"];
            [self.inputPwdView clearUpPassword];
            return;
        }
        
        //开始修改支付密码
        [[XNPasswordManagerModule defaultModule] userModifyPayPassword:self.oldPayPassword NewPwd:self.firstPayPassword];
        [self.view showGifLoading];
    }
}

#pragma mark - 验证支付密码回调
- (void)XNUserModuleVerifyPayPasswordDidReceive:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    if (module.userVerifyPayPwdMode.result) {
        
        [self.inputPwdView clearUpPassword];
        self.titleLabel.text = @"请设置新的交易密码";
        self.payStatus = InputNewPayPwdStatus;
    }else
    {
        [self.inputPwdView clearUpPassword];
        self.titleLabel.text = @"密码错误，请重新输入";
        [self showCustomWarnViewWithContent:@"交易密码错误"];
    }
}

- (void)XNUserModuleVerifyPayPasswordDidFailed:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 修改支付密码
- (void)XNUserModuleModifyPayPasswordDidReceive:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    [_KEY_WINDOW showCustomWarnViewWithContent:@"支付密码修改成功" Completed:^(){
        
        [_UI popViewControllerFromRoot:YES ToNavigationCtrl:@"MIPasswordManageController" comlite:nil];
    }];
}

- (void)XNUsermoduleModifyPayPasswordDidFailed:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

////////////////////////
#pragma mark - setter/getter
/////////////////////////////////

#pragma mark - forgetPwdBtn
- (UIButton *)forgetPwdBtn
{
    if (!_forgetPwdBtn) {
        
        _forgetPwdBtn = [[UIButton alloc]init];
        [_forgetPwdBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_forgetPwdBtn setTitleColor:COMMON_BLUE forState:UIControlStateNormal];
        [_forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPwdBtn addTarget:self action:@selector(clickForgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwdBtn;
}

@end
