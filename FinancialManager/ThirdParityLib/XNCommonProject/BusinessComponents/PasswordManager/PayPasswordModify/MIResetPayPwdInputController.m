//
//  MIResetPayPwdInputController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIResetPayPwdInputController.h"

#import "XNPasswordManagerModule.h"
#import "XNPasswordManagerObserver.h"

@interface MIResetPayPwdInputController ()<PasswordViewDelegate,XNPasswordManagerObserver>

@property (nonatomic, strong) UILabel                * warningLabel;
@property (nonatomic, strong) NSString               * firstPayPassword;
@property (nonatomic, strong) NSString               * confirmPayPassword;
@property (nonatomic, assign) ModifyPayPwdType payStatus;
@end

@implementation MIResetPayPwdInputController

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
    self.title = @"重置交易密码";
    self.inputPwdView.delegate = self;
    self.titleLabel.text = @"请设置新的交易密码";
    self.firstPayPassword = @"";
    self.confirmPayPassword = @"";
    self.payStatus = InputNewPayPwdStatus;
    
    [self.view addSubview:self.warningLabel];
    
    weakSelf(weakSelf)
    __weak SetPasswordView * tmpView = self.inputPwdView;
    [self.warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(weakSelf.view.mas_leading).offset(12);
        make.top.mas_equalTo(tmpView.mas_bottom).offset(24);
        make.height.mas_equalTo(12);
    }];
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
        self.titleLabel.text = @"请再次输入新的交易密码";
        [self.inputPwdView clearUpPassword];
    }else
    {
        self.confirmPayPassword = password;
        if (![self.firstPayPassword isEqualToString:self.confirmPayPassword]) {
            
            self.payStatus = InputNewPayPwdStatus;
            self.titleLabel.text = @"请设置新的交易密码";
            [self showCustomWarnViewWithContent:@"二次密码不一致，请重新输入"];
            [self.inputPwdView clearUpPassword];
            return;
        }
        
        //开始修改支付密码
        [[XNPasswordManagerModule defaultModule] userResetPayPassword:self.firstPayPassword];
        [self.view showGifLoading];
    }
}

#pragma mark - 初始化支付密码
- (void)XNUserModuleResetPayPasswordDidReceive:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    [_KEY_WINDOW showCustomWarnViewWithContent:@"设置成功" Completed:^(){
        
        [_UI popToRootViewController:YES];
    }];
    
}

- (void)XNUsermoduleResetPayPasswordDidFailed:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    [self.inputPwdView clearUpPassword];
    self.payStatus = InputNewPayPwdStatus;
    self.titleLabel.text = @"请设置新的交易密码";
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//////////////////////
#pragma mark - setter/getter
/////////////////////////////////////

#pragma mark - warningLabel
- (UILabel *)warningLabel
{
    if (!_warningLabel) {
        
        _warningLabel = [[UILabel alloc]init];
        [_warningLabel setFont:[UIFont systemFontOfSize:12]];
        [_warningLabel setTextColor:[UIColor blackColor]];
        [_warningLabel setText:@"交易密码将用于账户提现操作，请妥善设置和管理"];
    }
    return _warningLabel;
}

@end
