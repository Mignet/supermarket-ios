//
//  UseRegViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/12/18.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UseRegViewController.h"

#import "UniversalInteractWebViewController.h"

#import "NSString+common.h"

#import "XNLoginMode.h"
#import "XNUserModule.h"
#import "XNUserModuleObserver.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

@interface UseRegViewController ()<XNUserModuleObserver>

@property (nonatomic, assign) BOOL agreeStatus;
@property (nonatomic, strong) NSTimer                * timer;
@property (nonatomic, strong) NSString               * mobile;
@property (nonatomic, assign) NSInteger                timerCount;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic, weak) IBOutlet UILabel     * titleLabel;
@property (nonatomic, weak) IBOutlet UIButton * sendValicatedCodeBtn;
@property (nonatomic, weak) IBOutlet UITextField * valicatedCodeTextField;
@property (nonatomic, weak) IBOutlet UITextField * passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField * coformPasswordTextField;
@property (nonatomic, weak) IBOutlet UITextField * invitedPeoplePhoneTextField;
@property (nonatomic, weak) IBOutlet UIButton    * agreeBtn;
@property (nonatomic, weak) IBOutlet UILabel     * customerPhoneLabel;
@end

@implementation UseRegViewController

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil mobile:(nullable NSString *)mobile
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.mobile = mobile;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[XNUserModule defaultModule] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.timer invalidate];
    _timer = nil;
    [super viewDidDisappear:animated];
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
    self.timerCount = 60;
    self.agreeStatus = YES;
    [self.titleLabel setText:[NSString stringWithFormat:@"已发送验证码短信至%@",[self.mobile convertToSecurityPhoneNumber]]];
    
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
    //umeng统计点击次数－注册_完成
    [XNUMengHelper umengEvent:@"Q_2_3"];
    
    if (self.valicatedCodeTextField.text.length <= 0) {
        
        [self.view showCustomWarnViewWithContent:XNInputVeCodeEmpty];
        return;
    }
    
    if (self.passwordTextField.text.length <= 0) {
        
        [self.view showCustomWarnViewWithContent:XNRegisterInputPasswordEmpty];
        return;
    }
    
    if (![self.passwordTextField.text isValidatePassword]) {
        
        [self.view showCustomWarnViewWithContent:XNInputPasswordFormatError];
        return;
    }
    
    if (![self.passwordTextField.text isEqualToString:self.coformPasswordTextField.text]) {
        
        [self.view showCustomWarnViewWithContent:XNRegisterTwoInputPasswordUnSame];
        return;
    }
    
    if (!self.agreeStatus) {
        
        [self.view showCustomWarnViewWithContent:XNRegisterUnAggreeProtocol];
        return;
    }
    
    [[XNUserModule defaultModule] userRegisterWithMobile:self.mobile password:self.passwordTextField.text vcode:self.valicatedCodeTextField.text];
    [self.view showGifLoading];
}

#pragma mark - 查看协议
- (IBAction)clickCheckProtocal:(id)sender
{
    UniversalInteractWebViewController * webCtrl = [[UniversalInteractWebViewController alloc]initRequestUrl:[[[XNCommonModule defaultModule] configMode] cfpRegisterProtocol] requestMethod:@"GET"];
    
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

#pragma mark -获取验证码
- (IBAction)clickGetCode:(id)sender
{
    if (self.timerCount <= 0) {
        
    self.timerCount = 60;
    
    [self.timer setFireDate:[NSDate distantPast]];
    [self.sendValicatedCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}
#pragma mark - 定时器更新
- (void)updateTime
{
    self.timerCount--;
    
    [self.sendValicatedCodeBtn setTitle:[NSString stringWithFormat:@"重发(%@)",[NSNumber numberWithInteger:self.timerCount]] forState:UIControlStateNormal];
    if (self.timerCount <= 0) {
        
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.sendValicatedCodeBtn setTitleColor:UIColorFromHex(0xef4a3b) forState:UIControlStateNormal];
        [self.sendValicatedCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        return;
    }
    [self.sendValicatedCodeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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
    [_LOGIC saveValueForKey:XN_USER_MOBILE_TAG Value:[NSString encryptUseDES:self.mobile]];
    [_LOGIC saveValueForKey:XN_USER_GESTURE_INPUT_ERROR_COUNT_TAG Value:@"5"];
    [[NSNotificationCenter defaultCenter] postNotificationName:XN_USER_LOGIN_SUCCESS_NOTIFICATINO object:nil];
    
    [_LOGIC saveInt:1 key:self.customerPhoneLabel.text];
    
    weakSelf(weakSelf)
    NSInteger status = [[_LOGIC getValueForKey:COMMON_APP_LOGIN_SATTUS] intValue];
    if (status == 0) {
        
        //设置手势密码
        [_UI dismissNaviModalViewCtrlAnimated:YES completion:^{
            
            //umeng统计点击次数－注册_设置手势密码
            [XNUMengHelper umengEvent:@"Q_register_set_gestures"];
            
            [weakSelf performSelector:@selector(setGesture) withObject:nil afterDelay:0.3f];
        }];
    }else
    {
        [_UI popViewControllerFromRoot:YES ToNavigationCtrl:nil comlite:^{
            
            [weakSelf performSelector:@selector(setGesture) withObject:nil afterDelay:0.3f];
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

#pragma mark - timer
- (NSTimer *)timer
{
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    }
    
    return _timer;
}

#pragma mark - tapGesture
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitKeyboard)];
    }
    return _tapGesture;
}

@end
