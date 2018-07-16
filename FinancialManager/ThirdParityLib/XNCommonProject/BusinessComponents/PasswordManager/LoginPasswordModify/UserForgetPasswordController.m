//
//  UserForgetPasswordController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/10.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UserForgetPasswordController.h"

#import "UserPasswordValidateCodeViewController.h"

#import "XNUserModule.h"
#import "XNUserModuleObserver.h"

@interface UserForgetPasswordController ()<XNUserModuleObserver>

@property (nonatomic, assign) BOOL                     hideStatus;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;


@property (nonatomic, weak) IBOutlet UITextField     * phoneTextField;
@end

@implementation UserForgetPasswordController

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[XNUserModule defaultModule] addObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[XNUserModule defaultModule] removeObserver:self];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////
#pragma mark - Custom Method
////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"找回登录密码";
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 返回操作
- (void)clickBack:(UIButton *)sender
{
    [_UI popViewControllerFromRootDidHideNavigationBar:self.hideStatus animated:YES];
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

#pragma mark - 确定
- (IBAction)clickConfirm:(id)sender
{
    if ([self.phoneTextField.text isEqualToString:@""]) {
        
        [self showCustomWarnViewWithContent:XNLoginUserAccountEmpty];
        return;
    }
    
    if (self.phoneTextField.text.length < 11) {
        
        [self showCustomWarnViewWithContent:XNLoginUserAccountLengthWarn];
        return;
    }
    
    if(![self.phoneTextField.text isValidateMobile])
    {
        [self showCustomWarnViewWithContent:XNLoginUserAccountFormatError];
        return;
    }
    
    [[XNUserModule defaultModule] userSendVCodeWithMobile:self.phoneTextField.text VCodeType:UserResetLoginPasswordVCode];
    [self.view showGifLoading];
}

////////////////////
#pragma mark - Protocal
//////////////////////////////////

#pragma mark - 
- (void)XNUserModuleVCodeDidReceive:(XNUserModule *)module
{
    [self.view hideLoading];
    UserPasswordValidateCodeViewController * ctrl = [[UserPasswordValidateCodeViewController alloc]initWithNibName:@"UserPasswordValidateCodeViewController" bundle:nil hideNavigationStatus:self.hideStatus];
    
    ctrl.phoneNumber = self.phoneTextField.text;
    [_UI pushViewControllerFromRoot:ctrl animated:YES];
}

- (void)XNUsermoduleVCodeDidFailed:(XNUserModule *)module
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
