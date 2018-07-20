//
//  UseLoginViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/25.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UseLoginViewController.h"

#import "UserForgetPasswordController.h"
#import "UserValidateViewController.h"

#import "XNUserModule.h"
#import "XNLoginMode.h"
#import "IMManager.h"

#import "XNCommonModule.h"
#import "XNCommonModuleObserver.h"

@interface UseLoginViewController ()<XNUserModuleObserver,XNCommonModuleObserver,UITextFieldDelegate>

@property (nonatomic, assign) BOOL     showPassword;
@property (nonatomic, assign) BOOL     setGesture;
@property (nonatomic, assign) BOOL     passwordLoginStatus;
@property (nonatomic, assign) CGFloat  keyboardHeight;
@property (nonatomic, assign) CGSize   contentSizeHeight;
@property (nonatomic, strong) NSString               * phoneNumberStr;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, weak) IBOutlet UITextField  * phoneTextField;
@property (nonatomic, weak) IBOutlet UILabel      * userNameSeperatorLineLabel;
@property (nonatomic, weak) IBOutlet UITextField  * alPasswordTextField;
@property (nonatomic, weak) IBOutlet UILabel      * alPasswordSeperatorLineLabel;
@property (nonatomic, weak) IBOutlet UIButton     * alPasswordShowBtn;
@property (nonatomic, weak) IBOutlet UIButton     * alLoginButton;
@property (nonatomic, strong) IBOutlet UIView       * accountLoginHeaderView;

@property (nonatomic, weak) IBOutlet UILabel      * phoneNumberLabel;
@property (nonatomic, strong) IBOutlet UITextField  * flPasswordTextField;
@property (nonatomic, weak) IBOutlet UILabel      * flPasswordSeperatorLineLabel;
@property (nonatomic, weak) IBOutlet UIButton     * flPasswordShowBtn;
@property (nonatomic, weak) IBOutlet UIButton     * plLoginButton;
@property (nonatomic, strong) IBOutlet UIView       * passwordLoginHeaderView;

@property (nonatomic, weak) IBOutlet UIView       * safeFooterView;
@property (nonatomic, weak) IBOutlet UIScrollView * containerScrollView;
@end

@implementation UseLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[XNUserModule defaultModule] addObserver:self];
    [[XNCommonModule defaultModule] addObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[XNUserModule defaultModule] removeObserver:self];
    [[XNCommonModule defaultModule] removeObserver:self];
    self.flPasswordTextField.text = @"";
    self.alPasswordTextField.text = @"";
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (@available(iOS 11.0, *)) {
        
        self.containerScrollView.contentInset = UIEdgeInsetsMake(safeAreaInsets(self.view).top,0,safeAreaInsets(self.view).bottom,0);
    }
}

//////////////////
#pragma mark - Custom Method
///////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.showPassword = NO;
    self.keyboardHeight = 0.0f;
    self.contentSizeHeight = CGSizeZero;
    self.needNewSwitchViewAnimation = YES;
    
    NSInteger status = 0;
    NSString * phoneNumber = [_LOGIC getValueForKey:XN_USER_MOBILE_TAG];
    if ([NSObject isValidateObj:phoneNumber]) {
        
        phoneNumber = [NSString decryptUseDES:phoneNumber];
        if ([NSObject isValidateInitString:phoneNumber]) {
            
            status = 1;
        }
    }
    [self switchLogin:status];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {

        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

//切换登录界面-0表示无记录登录，1表示有记录登录
- (void)switchLogin:(NSInteger)status
{
    [self.accountLoginHeaderView removeFromSuperview];
    [self.passwordLoginHeaderView removeFromSuperview];
    
    CGFloat loginHeaderHeight = 0.0f;
    __weak UIView * tmpView = nil;
    __weak UIScrollView * tmpScrollView = self.containerScrollView;
    if (status == 0) {
        
        self.passwordLoginStatus = NO;
        self.phoneNumberStr = @"";
        
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"登录密码" attributes:
                                          @{NSForegroundColorAttributeName:UIColorFromHex(0x999999),
                                            NSFontAttributeName:self.flPasswordTextField.font
                                            }];
        self.alPasswordTextField.attributedPlaceholder = attrString;
        
       NSAttributedString * ptAttrString = [[NSAttributedString alloc] initWithString:@"手机号码" attributes:
                      @{NSForegroundColorAttributeName:UIColorFromHex(0x999999),
                        NSFontAttributeName:self.phoneTextField.font
                        }];
        self.phoneTextField.attributedPlaceholder = ptAttrString;
        
        [self.containerScrollView addSubview:self.accountLoginHeaderView];
    
        [self.accountLoginHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpScrollView.mas_leading);
            make.top.mas_equalTo(tmpScrollView.mas_top);
            make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(392 + (45*SCREEN_FRAME.size.width / 320.0));
        }];
        
        loginHeaderHeight = 392 + (45*SCREEN_FRAME.size.width / 320.0);
        tmpView = self.accountLoginHeaderView;
        
        [self.alPasswordShowBtn setImage:[UIImage imageNamed:@"XN_Login_eye_close_icon"
                          ] forState:UIControlStateNormal];
        [self.alPasswordShowBtn setImageEdgeInsets:UIEdgeInsetsMake(28, 20, 12, 10)];
    }else
    {
        self.passwordLoginStatus = YES;
        
        NSString * phoneNumber = [_LOGIC getValueForKey:XN_USER_MOBILE_TAG];
        self.phoneNumberStr = [NSString decryptUseDES:phoneNumber];
        [self.phoneNumberLabel setText:[self.phoneNumberStr convertToSecurityPhoneNumber]];
        
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"登录密码" attributes:
                                          @{NSForegroundColorAttributeName:UIColorFromHex(0x999999),
                                            NSFontAttributeName:self.flPasswordTextField.font
                                            }];
        self.flPasswordTextField.attributedPlaceholder = attrString;
        
        [self.containerScrollView addSubview:self.passwordLoginHeaderView];
        
        [self.passwordLoginHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(tmpScrollView.mas_leading);
            make.top.mas_equalTo(tmpScrollView.mas_top);
            make.trailing.mas_equalTo(tmpScrollView.mas_trailing);
            make.width.mas_equalTo(SCREEN_FRAME.size.width);
            make.height.mas_equalTo(378 + (45*SCREEN_FRAME.size.width / 320.0));
        }];
        
        loginHeaderHeight = 378 + (45*SCREEN_FRAME.size.width / 320.0);
        tmpView = self.passwordLoginHeaderView;
        
        [self.flPasswordShowBtn setImage:[UIImage imageNamed:@"XN_Login_eye_close_icon"
                                          ] forState:UIControlStateNormal];
        [self.flPasswordShowBtn setImageEdgeInsets:UIEdgeInsetsMake(28, 20, 12, 10)];
    }
    
    [self.containerScrollView addSubview:self.safeFooterView];
    
    [self.safeFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(tmpScrollView).offset(4);
        make.top.mas_equalTo(tmpView.mas_bottom).offset(SCREEN_FRAME.size.height - loginHeaderHeight - 15 - 26);
        make.bottom.mas_equalTo(tmpScrollView.mas_bottom).offset(- 15);
        make.height.mas_equalTo(@(26));
        make.width.mas_equalTo(@(255));
    }];
}

#pragma mark - 显示密码/隐藏密码
- (IBAction)showPasswordClick:(UIButton *)sender
{
    self.showPassword = !self.showPassword;

    if (self.showPassword)
    {
        [sender setImage:[UIImage imageNamed:@"XN_Login_eye_open_icon"
                                        ] forState:UIControlStateNormal];
        [sender setImageEdgeInsets:UIEdgeInsetsMake(25, 20, 10, 10)];
    }else
    {
        [sender setImage:[UIImage imageNamed:@"XN_Login_eye_close_icon"
                                        ] forState:UIControlStateNormal];
        [sender setImageEdgeInsets:UIEdgeInsetsMake(28, 20, 12, 10)];
    }
    
    if (!self.passwordLoginStatus) {
        
        [self.alPasswordTextField setSecureTextEntry:!self.showPassword];
    }else
    {
        [self.flPasswordTextField setSecureTextEntry:!self.showPassword];
    }
}

#pragma mark - 用户登入
- (IBAction)loginAction:(UIButton *)sender
{
    [XNUMengHelper umengEvent:@"Q_1_1"];

    NSString * passwordStr = @"";
    if (!self.passwordLoginStatus) {
        
        if ([self.phoneTextField.text isEqualToString:@""]) {
            
            [self.view showCustomWarnViewWithContent:XNLoginUserAccountEmpty];
            return;
        }
        
        if (self.phoneTextField.text.length < 11) {
            
            [self.view showCustomWarnViewWithContent:XNLoginUserAccountLengthWarn];
            return;
        }
        
        if (![self.phoneTextField.text isValidateMobile]) {
            
            [self.view showCustomWarnViewWithContent:XNLoginUserAccountFormatError];
            return;
        }
        
        if ([self.alPasswordTextField.text length] <= 0) {
            
            [self.view showCustomWarnViewWithContent:XNLoginPasswordLengthWarn];
            return;
        }
        
        self.phoneNumberStr = self.phoneTextField.text;
        passwordStr = self.alPasswordTextField.text;
    }else
    {
        if ([self.flPasswordTextField.text length] <= 0) {
            
            [self.view showCustomWarnViewWithContent:XNLoginPasswordLengthWarn];
            return;
        }
        
        passwordStr = self.flPasswordTextField.text;
    }
    
    [self exitKeyboard:nil];
    
    //开始进行网络请求
    [[XNUserModule defaultModule] userLoginPhoneNumber:self.phoneNumberStr Password:[passwordStr stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [self.view showGifLoading];
}

#pragma mark - 忘记密码
- (IBAction)forgetPasswordAction:(id)sender
{
    UserForgetPasswordController * forgetCtrl = [[UserForgetPasswordController alloc]initWithNibName:@"UserForgetPasswordController" bundle:nil hideNavigationStatus:YES];
    forgetCtrl.needNewSwitchViewAnimation = YES;
    
    [_UI pushViewControllerFromRoot:forgetCtrl hideNavigationBar:NO animated:YES];
}

#pragma mark - 免费注册
- (IBAction)registerAction:(id)sender
{
    [XNUMengHelper umengEvent:@"Q_2_1"];
    
    UserValidateViewController * regCtrl = [[UserValidateViewController alloc]initWithNibName:@"UserValidateViewController" bundle:nil];
    regCtrl.needNewSwitchViewAnimation = YES;
    
    [_LOGIC saveInt:0 key:COMMON_APP_LOGIN_SATTUS];//设置登录来源（0表示登录界面登录，1表示注册登录)
    
    [_UI pushViewControllerFromRoot:regCtrl hideNavigationBar:NO animated:YES];
}

//退出
- (IBAction)clickExit:(id)sender
{
    [_UI dismissNaviModalViewCtrlAnimated:YES];
}

//切换账号
- (IBAction)clickSwitchAccount:(id)sender
{
    [self switchLogin:0];
}

- (void)keyboardShow:(NSNotification *)notif
{
    [self.view addGestureRecognizer:self.tapGesture];
    
    NSDictionary * notifDic = [notif userInfo];
    
    NSValue * endValue = [notifDic objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [endValue CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
    self.contentSizeHeight = self.containerScrollView.contentSize;
    
    CGFloat finterval = 0.0f;
    
    if (!self.passwordLoginStatus) {
        
        finterval = keyboardRect.size.height - (SCREEN_FRAME.size.height - self.alLoginButton.frame.origin.y - self.alLoginButton.frame.size.height);
    }else
    {
        finterval = keyboardRect.size.height - (SCREEN_FRAME.size.height - self.plLoginButton.frame.origin.y - self.plLoginButton.frame.size.height);
    }
    
    NSValue * animationDurationValue = [notifDic objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (finterval > 0) {
        
        [self.containerScrollView setContentSize:CGSizeMake(SCREEN_FRAME.size.width, SCREEN_FRAME.size.height + finterval)];
        [UIView animateWithDuration:animationDuration animations:^{
            [self.containerScrollView setContentOffset:CGPointMake(0 ,
                                                                   finterval)];
        }];
    }
}

- (void)keyboardHide:(NSNotification *)notif
{
    [self.view removeGestureRecognizer:self.tapGesture];

    NSDictionary * notifDic = [notif userInfo];

    NSValue * animationDurationValue = [notifDic objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    if (!Device_Is_iPhoneX) {
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            [self.containerScrollView setContentOffset:CGPointMake(0, 0)];
            [self.containerScrollView setContentSize:CGSizeMake(0, 0)];
        }];
    }
}

#pragma mark - 退出键盘
- (void)exitKeyboard:(UIGestureRecognizer *)gesture
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

//完成配置
- (void)finishedLogin
{
    if (self.setGesture) {
        
        [_UI dismissNaviModalViewCtrlAnimated:YES completion:^{
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:XN_USER_LOGIN_SET_GESTURE_NOTIFICATION object:nil];
            
            UIViewController * lastCtrl = [_UI topControllerUnderLoginModelViewController];
            
            if (lastCtrl.switchToHomePage) {
                
                [_UI popToRootViewController:NO];
            }
            [lastCtrl setSwitchToHomePage:YES];
        }];
    }else
    {
        [_UI dismissNaviModalViewCtrlAnimated:YES completion:^{
            
        
            UIViewController * lastCtrl = [_UI topControllerUnderLoginModelViewController];
            if (lastCtrl.switchToHomePage) {
                
                [_UI popToRootViewController:NO];
            }
            [lastCtrl setSwitchToHomePage:YES];
        }];
    }
}

//////////////////////
#pragma mark - Protocol
///////////////////////////////////

#pragma mark - XNUserModuleObserver
- (void)XNUserModuleLoginDidReceive:(XNUserModule *)module
{
    //退出当前账户
    [[IMManager defaultIMManager] imManagerLogout];
    
    [_LOGIC saveValueForKey:XN_USER_TOKEN_TAG Value:[NSString encryptUseDES:module.loginMode.token]];
    [_LOGIC saveValueForKey:XN_USER_GESTURE_INPUT_ERROR_COUNT_TAG Value:@"5"];
    [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"0"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_USER_LOGIN_SUCCESS_NOTIFICATINO object:nil];
    
    //保存相关信息
    self.setGesture = NO;
    
    //如果系统中不存在对应的手机帐号，则设置手势密码
    if (![NSObject isValidateObj:[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]) {
       
        self.setGesture = YES;
    //如果系统中存的手机帐号与当前登录的不一样
    }else if (![[_LOGIC getValueForKey:XN_USER_MOBILE_TAG] isEqualToString:[NSString encryptUseDES:[self.phoneNumberStr stringByReplacingOccurrencesOfString:@" " withString:@""]]])
    {
        
        
        //如果当前手机帐号对应的手势密码不存在，则设置手势密码
        if (![NSObject isValidateObj:[_LOGIC getValueForKey:[NSString encryptUseDES:[self.phoneNumberStr stringByReplacingOccurrencesOfString:@" " withString:@""]]]] || ![NSObject isValidateInitString:[_LOGIC getValueForKey:[NSString encryptUseDES:[self.phoneNumberStr stringByReplacingOccurrencesOfString:@" " withString:@""]]]])
        {
            self.setGesture = YES;
        }
    
    //如果之前存储的手机帐号对应的手势密码不存在，则设置手势密码
    }else if(![NSObject isValidateObj:[_LOGIC getValueForKey:[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]] || ![NSObject isValidateInitString:[_LOGIC getValueForKey:[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]])
    {
        self.setGesture = YES;
        
    //如果通过忘记密码的方式找回密码并登录，则设置新的手势密码
    }else if(self.canReSetGesture)
        self.setGesture = YES;
    
    [_LOGIC saveValueForKey:XN_USER_MOBILE_TAG Value:[NSString encryptUseDES:[self.phoneNumberStr stringByReplacingOccurrencesOfString:@" " withString:@""]]];

    [self finishedLogin];
}

- (void)XNUserModuleLoginDidFailed:(XNUserModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject] Completed:nil showTime:2.0];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg Completed:nil showTime:2.0];
}

//UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.phoneTextField]) {
        
        [self.userNameSeperatorLineLabel setBackgroundColor:UIColorFromHex(0x4e8cef)];
        [self.alPasswordSeperatorLineLabel setBackgroundColor:UIColorFromHex(0xefefef)];
    }else if([textField isEqual:self.alPasswordTextField])
    {
        [self.userNameSeperatorLineLabel setBackgroundColor:UIColorFromHex(0xefefef)];
        [self.alPasswordSeperatorLineLabel setBackgroundColor:UIColorFromHex(0x4e8cef)];
    }else
    {
        [self.flPasswordSeperatorLineLabel setBackgroundColor:UIColorFromHex(0x4e8cef)];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.phoneTextField]) {
        
        [self.alLoginButton setEnabled:NO];
        if (self.alPasswordTextField.text.length > 0) {
            
            if (([string isEqualToString:@""] && textField.text.length - 1 > 0) || ![string isEqualToString:@""]) {
                
                 [self.alLoginButton setEnabled:YES];
            }
        }
    }else if([textField isEqual:self.alPasswordTextField])
    {
        [self.alLoginButton setEnabled:NO];
        if (self.phoneTextField.text.length > 0) {
            
            if (([string isEqualToString:@""] && textField.text.length - 1> 0) || ![string isEqualToString:@""]) {
                
                [self.alLoginButton setEnabled:YES];
            }
        }
    }else
    {
        [self.plLoginButton setEnabled:NO];
        if (([string isEqualToString:@""] && textField.text.length - 1> 0) || ![string isEqualToString:@""]) {
            
            [self.plLoginButton setEnabled:YES];
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([textField isEqual:self.phoneTextField] || [textField isEqual:self.alPasswordTextField]) {
        
        [self.alLoginButton setEnabled:NO];
    }else
    {
        [self.plLoginButton setEnabled:NO];
    }
    
    return YES;
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
