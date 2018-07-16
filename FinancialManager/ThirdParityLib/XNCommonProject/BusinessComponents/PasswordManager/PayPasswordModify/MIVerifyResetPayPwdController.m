//
//  MIVerifyResetPayPwdController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/13.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIVerifyResetPayPwdController.h"

#import "XNUserVerifyVCodeMode.h"
#import "XNUserModule.h"
#import "XNUserModuleObserver.h"

#import "XNPasswordManagerModule.h"
#import "XNPasswordManagerObserver.h"

#import "MIResetPayPwdInputController.h"

@interface MIVerifyResetPayPwdController ()<XNPasswordManagerObserver,XNUserModuleObserver>

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, strong) NSTimer                * timer;
@property (nonatomic, assign) NSInteger countDownTime;
@property (nonatomic, assign) BOOL      backOperation;

@property (nonatomic, weak) IBOutlet UITextField     * inputVCodeTextField;
@property (nonatomic, weak) IBOutlet UIButton        * reSendVCodeBtn;
@property (nonatomic, weak) IBOutlet UILabel         * titleLabel;
@end

@implementation MIVerifyResetPayPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[XNPasswordManagerModule defaultModule] addObserver:self];
    [[XNUserModule defaultModule] addObserver:self];
    
    if (self.backOperation)
    {
        
        self.backOperation = NO;
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.reSendVCodeBtn setEnabled:YES];
        self.countDownTime = 60;
        [self.reSendVCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.reSendVCodeBtn setTitleColor:COMMON_YELLOW forState:UIControlStateNormal];
    }
    else
    {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[XNPasswordManagerModule defaultModule] removeObserver:self];
    [[XNUserModule defaultModule] removeObserver:self];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////
#pragma mark - Custom Method
////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"重置交易密码";
    self.countDownTime = 60;
    self.titleLabel.text = [NSString stringWithFormat:@"已发送短信验证码到%@",[[NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]] convertToSecurityPhoneNumber]];
    self.backOperation = NO;
    
    [self.timer setFireDate:[NSDate distantPast]];
    
    [self.view addGestureRecognizer:self.tapGesture];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 确定操作
- (IBAction)clickNextStep:(id)sender
{
    [self tapAction:nil];
    
    if ([self.inputVCodeTextField.text isEqualToString:@""]) {
        
        [self showCustomWarnViewWithContent:XNInputVeCodeEmpty];
        return;
    }
    
    [[XNPasswordManagerModule defaultModule] userVerifyVCode:self.inputVCodeTextField.text];
    [self.view showGifLoading];
}

#pragma mark - 退出键盘
- (void)tapAction:(UIGestureRecognizer *)gesture
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 重新发送验证码
- (IBAction)clickReCode:(id)sender
{
    self.countDownTime = 60;
    [self.timer setFireDate:[NSDate distantPast]];
    [self.reSendVCodeBtn setEnabled:NO];
    [self.reSendVCodeBtn setTitleColor:COMMON_GREY_WORD forState:UIControlStateNormal];
    
    [[XNPasswordManagerModule defaultModule] accountSendVCode];
    
    
}

#pragma mark - 更新时间
- (void)updateTime
{
    self.countDownTime = self.countDownTime - 1;
    
    [self.reSendVCodeBtn setEnabled:NO];
    if (self.countDownTime <= 0) {
        
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.reSendVCodeBtn setEnabled:YES];
        [self.reSendVCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.reSendVCodeBtn setTitleColor:COMMON_YELLOW forState:UIControlStateNormal];
        return;
    }
    [self.reSendVCodeBtn setTitleColor:COMMON_GREY_WORD forState:UIControlStateNormal];
    [self.reSendVCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%@s)",@(self.countDownTime)] forState:UIControlStateNormal];
}


////////////////////
#pragma mark - Protocal
//////////////////////////////////////

#pragma mark - 验证验证码是否正确
- (void)XNUserModuleVerifyVCodeDidReceive:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    if (module.userVerifyVCodeMode.resetPayPwdToken) {
        
        self.backOperation = YES;
        MIResetPayPwdInputController * resetPayPwdInputCtrl = [[MIResetPayPwdInputController alloc]init];
        
        [_UI pushViewControllerFromRoot:resetPayPwdInputCtrl animated:YES];
    }
}

- (void)XNUsermoduleVerifyVCodeDidFaied:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

#pragma mark - 发送验证码失败
- (void)XNUserModuleSendVCodeDidFailed:(XNPasswordManagerModule *)module
{
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
    
    [self.timer setFireDate:[NSDate distantFuture]];
    [self.reSendVCodeBtn setEnabled:YES];
    [self.reSendVCodeBtn setTitleColor:COMMON_YELLOW forState:UIControlStateNormal];
}


///////////////////////
#pragma mark - setter/getter
//////////////////////////////////////////

#pragma mark - TapGesutre
- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
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
