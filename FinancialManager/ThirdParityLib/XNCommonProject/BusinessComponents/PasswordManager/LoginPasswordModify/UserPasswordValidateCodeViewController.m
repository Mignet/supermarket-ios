//
//  UserPasswordValidateCodeViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/10.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UserPasswordValidateCodeViewController.h"

#import "XNUserModule.h"
#import "XNUserModuleObserver.h"

#import "XNPasswordManagerModule.h"
#import "XNPasswordManagerObserver.h"

@interface UserPasswordValidateCodeViewController ()<XNUserModuleObserver,XNPasswordManagerObserver>

@property (nonatomic, assign) NSInteger countDownTime;
@property (nonatomic, assign) BOOL                     hideStatus;


@property (nonatomic, assign) BOOL  isShowPassword;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) NSTimer                * timer;

@property (nonatomic, weak) IBOutlet UITextField     * vCodeTextField;
@property (nonatomic, weak) IBOutlet UITextField     * passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton        * showBtn;
@property (nonatomic, weak) IBOutlet UIButton        * countDownBtn;
@property (nonatomic, weak) IBOutlet UILabel         * phoneLabel;
@end

@implementation UserPasswordValidateCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil hideNavigationStatus:(BOOL)hideStatus
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.hideStatus = hideStatus;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer setFireDate:[NSDate distantPast]];
    
    [self.phoneLabel setText:[NSString stringWithFormat:@"已发送短信验证码到%@",[self.phoneNumber convertToSecurityPhoneNumber]]];
    
    [[XNUserModule defaultModule] addObserver:self];
    [[XNPasswordManagerModule defaultModule] addObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[XNUserModule defaultModule] removeObserver:self];
    [[XNPasswordManagerModule defaultModule] removeObserver:self];
        
    [self.timer invalidate];
    self.timer = nil;
    
    [super viewDidDisappear:animated];
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"找回登录密码";
    self.countDownTime = 60;
    self.isShowPassword = NO;
    
    [self.timer setFireDate:[NSDate distantPast]];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 键盘显示
- (void)keyboardShow:(NSNotification *)notif
{
    [self.view addGestureRecognizer:self.tapGesture];
}

#pragma mark - 键盘隐藏
- (void)keyboardHide:(NSNotification *)notif
{
    [self.view removeGestureRecognizer:self.tapGesture];
}

#pragma mark - 退出键盘
- (void)exitKeyboard:(UITapGestureRecognizer *)gesture
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 返回操作
- (void)clickBack:(UIButton *)sender
{
    [_UI popViewControllerFromRootDidHideNavigationBar:NO animated:YES];
}

#pragma mark - 重新发送验证码
- (IBAction)clickReCode:(id)sender
{
    self.countDownTime = 60;
    [self.timer setFireDate:[NSDate distantPast]];
    [self.countDownBtn setEnabled:NO];
    
    [[XNUserModule defaultModule] userSendVCodeWithMobile:self.phoneNumber VCodeType:UserResetLoginPasswordVCode];
}

#pragma mark - 显示
- (IBAction)clickShow:(id)sender
{
    if (self.isShowPassword) {
        
        self.isShowPassword = NO;
        [self.showBtn setImage:[UIImage imageNamed:@"XN_MyInfo_close_icon"] forState:UIControlStateNormal];
        [self.passwordTextField setSecureTextEntry:YES];
    }else
    {
        self.isShowPassword = YES;
         [self.showBtn setImage:[UIImage imageNamed:@"XN_MyInfo_eye_icon"] forState:UIControlStateNormal];
        [self.passwordTextField setSecureTextEntry:NO];
    }
}

#pragma mark - 完成
- (IBAction)clickFinished:(id)sender
{
    if ([self.vCodeTextField.text isEqualToString:@""]) {
        
        [self showCustomWarnViewWithContent:XNInputVeCodeEmpty];
        return;
    }
    
    if ([self.passwordTextField.text isEqualToString:@""]) {
        
        [self showCustomWarnViewWithContent:XNForgetPasswordNewPasswordEmpty];
        return;
    }
    
    if (![self.passwordTextField.text isValidatePassword]) {
        
        [self showCustomWarnViewWithContent:XNInputPasswordFormatError];
        return;
    }
    
    [[XNPasswordManagerModule defaultModule] userResetLoginPasswordWithPhone:self.phoneNumber VCode:self.vCodeTextField.text NewPwd:self.passwordTextField.text];
    [self.view showGifLoading];
}

#pragma mark - 更新时间
- (void)updateTime
{
    self.countDownTime = self.countDownTime - 1;
    
    [self.countDownBtn setEnabled:NO];
    [self.countDownBtn setTitleColor:UIColorFromHex(0x969696) forState:UIControlStateNormal];
    if (self.countDownTime <= 0) {
        
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.countDownBtn setEnabled:YES];
        [self.countDownBtn setTitleColor:PHONEVIEW_CONFIRM_BACKGROUND forState:UIControlStateNormal];
        [self.countDownBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        return;
    }
    
    [self.countDownBtn setTitle:[NSString stringWithFormat:@"重新发送(%@s)",@(self.countDownTime)] forState:UIControlStateNormal];
}

////////////////////
#pragma mark - Protocal
//////////////////////////////////

#pragma mark -
- (void)XNUserModuleResetLoginPasswordDidReceive:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    
    [self.view showCustomWarnViewWithContent:@"成功找回密码" Completed:^{
        
        [_UI popToRootViewController:YES];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
    }];
}

- (void)XNUserModuleResetLoginPasswordDidFailed:(XNPasswordManagerModule *)module
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

#pragma mark - timer
- (NSTimer *)timer
{
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
@end
