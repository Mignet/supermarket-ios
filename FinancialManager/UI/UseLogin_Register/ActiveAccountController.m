//
//  ActiveAccountController.m
//  FinancialManager
//
//  Created by xnkj on 15/12/18.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "ActiveAccountController.h"

#import "UniversalInteractWebViewController.h"

#import "XNLoginMode.h"
#import "XNUserModule.h"
#import "XNUserModuleObserver.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

@interface ActiveAccountController ()<XNUserModuleObserver>

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, assign) BOOL agreeStatus;

@property (nonatomic, strong) NSString           * mobile;
@property (nonatomic, strong) NSString           * regFrom;

@property (nonatomic, weak) IBOutlet UILabel     * regFromLabel;
@property (nonatomic, weak) IBOutlet UITextField * phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField * passwordTextField;
@property (nonatomic, weak) IBOutlet UIButton    * agreeBtn;
@property (nonatomic, weak) IBOutlet UILabel     * customerPhoneLabel;
@end

@implementation ActiveAccountController

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil mobile:(nullable NSString *)mobile resource:(nullable NSString *)reg
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.mobile = mobile;
        self.regFrom = reg;
        return self;
    }
    return nil;
}

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
    self.agreeStatus = YES;
    [self.phoneTextField setText:self.mobile];
    [self.regFromLabel setText:[NSString stringWithFormat:@"您是%@用户，输入登录密码可直接激活",self.regFrom]];
    [self.passwordTextField setPlaceholder:[NSString stringWithFormat:@"请输入您的%@登录密码",self.regFrom]];
    
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
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 激活
- (IBAction)clickNextStep:(id)sender
{
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
    
    if (self.passwordTextField.text.length <= 0) {
        
        [self.view showCustomWarnViewWithContent:XNLoginPasswordLengthWarn];
        return;
    }
    
    if (![self.passwordTextField.text isValidatePassword]) {
        
        [self.view showCustomWarnViewWithContent:XNInputPasswordFormatError];
        return;
    }

    if (!self.agreeStatus) {
        
        [self.view showCustomWarnViewWithContent:XNActiveUnAggreeProtocol];
        return;
    }
    
    [[XNUserModule defaultModule] userRegisterWithMobile:self.phoneTextField.text password:self.passwordTextField.text vcode:@""];
    [self.view showGifLoading];
}

#pragma mark - 查看协议
- (IBAction)clickCheckProtocal:(id)sender
{
    UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc] initRequestUrl:[[[XNCommonModule defaultModule] configMode] cfpRegisterProtocol] requestMethod:@"GET"];

    [_UI pushViewControllerFromRoot:webCtrl hideNavigationBar:NO animated:YES];
}

#pragma mark - 认同协议
- (IBAction)clickAgreeProtocal:(id)sender
{
    self.agreeStatus = !self.agreeStatus;
    
    [self.agreeBtn setImageEdgeInsets:UIEdgeInsetsZero];
    [self.agreeBtn setImage:[UIImage imageNamed:!self.agreeStatus? @"XN_MyInfo_AccountManager_UnCheck.png":@"XN_Login_Check.png"] forState:UIControlStateNormal];
    [self.agreeBtn setImageEdgeInsets:UIEdgeInsetsMake(9, 22, 7, 0)];
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
    [_UI popViewControllerFromRoot:YES];
}

//弹出手势密码设置
- (void)setGesture
{
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_USER_LOGIN_SET_GESTURE_NOTIFICATION object:nil];
}

/////////////////////////
#pragma mark - Protocal
///////////////////////////////////////

#pragma mark - 注册回调
- (void)XNUserModuleRegDidReceive:(XNUserModule *)module
{
    [self.view hideLoading];
    
    [_LOGIC saveValueForKey:XN_USER_TOKEN_TAG Value:[NSString encryptUseDES:module.loginMode.token]];
    [_LOGIC saveValueForKey:XN_USER_MOBILE_TAG Value:[NSString encryptUseDES:self.phoneTextField.text]];
    [_LOGIC saveValueForKey:XN_USER_GESTURE_INPUT_ERROR_COUNT_TAG Value:@"5"];
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_USER_LOGIN_SUCCESS_NOTIFICATINO object:nil];
    
    [_LOGIC saveInt:1 key:self.phoneTextField.text];
    
    weakSelf(weakSelf)
    NSInteger status = [[_LOGIC getValueForKey:COMMON_APP_LOGIN_SATTUS] intValue];
    if (status == 0) {
       
        //设置手势密码
        [_UI dismissNaviModalViewCtrlAnimated:YES completion:^{
            
            [weakSelf performSelector:@selector(setGesture) withObject:nil afterDelay:1.0f];
        }];
    }else
    {
        [_UI popViewControllerFromRoot:YES ToNavigationCtrl:nil comlite:^{
            
            [weakSelf performSelector:@selector(setGesture) withObject:nil afterDelay:1.0f];
        }];
    }
}

- (void)XNUserModuleRegDidFailed:(XNUserModule *)module
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
