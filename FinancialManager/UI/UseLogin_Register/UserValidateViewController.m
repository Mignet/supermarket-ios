//
//  UserRegViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/12/18.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UserValidateViewController.h"
#import "ActiveAccountController.h"
#import "UseRegViewController.h"

#import "XNUserIsRegMode.h"
#import "XNUserModule.h"
#import "XNUserModuleObserver.h"

@interface UserValidateViewController ()<XNUserModuleObserver>

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, weak) IBOutlet UITextField * phoneTextField;
@property (nonatomic, weak) IBOutlet UILabel     * customerPhoneLabel;
@property (nonatomic, weak) IBOutlet UILabel     * titleLabel;
@end

@implementation UserValidateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[XNUserModule defaultModule] addObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[XNUserModule defaultModule] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////
#pragma mark - Custom Methods
/////////////////////////////////////////////

#pragma mark - 初始化
- (void)initView
{
    self.title = @"注册";
    
    //读取文件
    NSDictionary * configDic = [_LOGIC readDicDataFromFileName:@"config.plist"];
    if (configDic == nil)
    {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"json"];
        NSData * data = [[NSData alloc]initWithContentsOfFile:path];
        
        NSError * error = nil;
        configDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    }
    [self.customerPhoneLabel setText:[NSString stringWithFormat:@"客服电话%@",[configDic objectForKey:@"serviceTelephone"]]];
    
    //根据前期的弹出状态分析当前是登录注册还是直接进入注册
    if (![[_UI topModelRootViewController] isKindOfClass:[UseLoginViewController class]]) {
        
        [_LOGIC saveValueForKey:COMMON_APP_LOGIN_SATTUS Value:@"1"];
    }else
    {
        [_LOGIC saveValueForKey:COMMON_APP_LOGIN_SATTUS Value:@"0"];
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 下一步
- (IBAction)clickNextStep:(id)sender
{
    [XNUMengHelper umengEvent:@"Q_2_2"];
    
    if ([self.phoneTextField.text isEqualToString:@""]) {
        
        [self showCustomWarnViewWithContent:XNLoginUserAccountEmpty];
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
    
    [self exitKeyboard];
    [[XNUserModule defaultModule] userIsRegisterWithMobile:self.phoneTextField.text recommendCode:@""];
    [self.view showGifLoading];
}

#pragma mark - 登入
- (IBAction)clickLogin:(id)sender
{
    [_UI popToRootViewController:YES];
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

#pragma mark - 返回
- (void)clickBack:(UIButton *)sender
{
    [_UI popViewControllerFromRootDidHideNavigationBar:YES animated:YES];
}

/////////////////////////
#pragma mark - Protocal
///////////////////////////////////////

#pragma mark -
- (void)XNUserModuleIsRegDidReceive:(XNUserModule *)module
{
    [self.view hideLoading];
    if ([module.isRegMode.regFlag isEqualToString:@"2"]) {
        
        [self.view showCustomWarnViewWithContent:@"您已经注册了理财师!" Completed:^{
            
            [_UI popToRootViewController:YES];
        }];
        return;
    }
    
    if (module.isRegMode.isRegLimit) {
        
        [self.titleLabel setText:module.isRegMode.regLimitMsg];
        
        [self showCustomAlertViewWithTitle:module.isRegMode.regLimitMsg okTitle:@"确定" okTitleColor:nil okCompleteBlock:nil];
        
        return;
    }
    
    //是理财师客户，需要升级
    if ([module.isRegMode.regFlag isEqualToString:@"1"]) {
        
        ActiveAccountController * activityAccountCtrl = [[ActiveAccountController alloc]initWithNibName:@"ActiveAccountController" bundle:nil mobile:self.phoneTextField.text resource:module.isRegMode.regSource];
        [_UI pushViewControllerFromRoot:activityAccountCtrl animated:YES];
        return;
    }
    
    if ([module.isRegMode.regFlag isEqualToString:@"0"]) {
        
        [[XNUserModule defaultModule] userSendVCodeWithMobile:self.phoneTextField.text VCodeType:UserRegisterVCode];
        UseRegViewController * regCtrl = [[UseRegViewController alloc]initWithNibName:@"UseRegViewController" bundle:nil mobile:self.phoneTextField.text];
        [_UI pushViewControllerFromRoot:regCtrl animated:YES];
    }
}

- (void)XNUserModuleIsRegDidFailed:(XNUserModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

/////////////////////////
#pragma mark - setter/getter
///////////////////////////////////////

#pragma mark - tapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitKeyboard)];
    }
    return _tapGesture;
}

@end
