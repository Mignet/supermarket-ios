//
//  MIResetPayPwdController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/13.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIResetPayPwdController.h"

#import "MIVerifyResetPayPwdController.h"

#import "XNUserVerifyIdentifyMode.h"
#import "XNPasswordManagerModule.h"
#import "XNPasswordManagerObserver.h"

#import "XNUserModule.h"

#import "XNConfigMode.h"
#import "XNCommonModule.h"

@interface MIResetPayPwdController ()<XNPasswordManagerObserver>

@property (nonatomic, weak) IBOutlet UILabel     * nameLabel;
@property (nonatomic, weak) IBOutlet UITextField * nameTextField;
@property (nonatomic, weak) IBOutlet UITextField * identifyTextField;
@property (nonatomic, weak) IBOutlet UILabel     * remindLabel;

@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@end

@implementation MIResetPayPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[XNPasswordManagerModule defaultModule] addObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[XNPasswordManagerModule defaultModule] removeObserver:self];
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
    
    [self.view addGestureRecognizer:self.tapGesture];
    
    weakSelf(weakSelf)
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        weakSelf.nameLabel.text = weakSelf.nameTextField.text;
    }];
    
    NSArray * arr_Property = @[@{@"range": @"为保障账户资金安全，请填写本账号已认证的身份信息进行重置密码验证。如有疑问请咨询客服",
                                 @"color": UIColorFromHex(0x969696),
                                 @"font": [UIFont systemFontOfSize:12]},
                               @{@"range": [[[XNCommonModule defaultModule] configMode] serviceTelephone],
                                 @"color": UIColorFromHex(0x007aff),
                                 @"font": [UIFont systemFontOfSize:12]}];
    [self.remindLabel refreshPropertyArray:arr_Property Alignment:NSTextAlignmentLeft];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 确定操作
- (IBAction)clickNextStep:(id)sender
{
    [self tapAction:nil];
    
    if ([self.nameTextField.text isEqualToString:@""]) {
        
        [self showCustomWarnViewWithContent:@"请输入您的姓名"];
        return;
    }
    
    if (![self.identifyTextField.text validateIdentityCard]) {
        
        [self showCustomWarnViewWithContent:@"请输入有效的身份证号"];
        return;
    }
    
    [[XNPasswordManagerModule defaultModule] userIdentifyVerifyWithName:self.nameTextField.text IdCard:self.identifyTextField.text];
    [self.view showGifLoading];
}

#pragma mark - 退出键盘
- (void)tapAction:(UIGestureRecognizer *)gesture
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

////////////////////
#pragma mark - Protocal
//////////////////////////////////////

#pragma mark - 验证身份证
- (void)XNUserModuleVerifyIdentifyDidReceive:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    
    if (module.userVerifyIdentifyMode.result) {
        
        //开始发送验证码
        [[XNPasswordManagerModule defaultModule] accountSendVCode];
        
        MIVerifyResetPayPwdController * verifyResetPayPwdCtrl = [[MIVerifyResetPayPwdController alloc]initWithNibName:@"MIVerifyResetPayPwdController" bundle:nil];
        
        [_UI pushViewControllerFromRoot:verifyResetPayPwdCtrl animated:YES];
        return;
    }
    
    [self showCustomWarnViewWithContent:@"身份验证失败!"];
}

- (void)XNUserModuleVerifyIdentifyDidFailed:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
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

@end
