//
//  UserModifyGestureController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/12.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "UserModifyGestureController.h"

#import "XNModifyGesturePasswordViewController.h"

#import "XNUserModule.h"

@interface UserModifyGestureController ()
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, weak) IBOutlet UITextField     * loginPasswordTextField;
@end

@implementation UserModifyGestureController

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
    self.title = @"修改手势密码";
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 返回操作
- (void)clickBack:(UIButton *)sender
{
    [_UI popViewControllerFromRoot:YES];
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
    if ([self.loginPasswordTextField.text isEqualToString:@""]) {
        
        [self showCustomWarnViewWithContent:XNMyInfoModifyGestureLoginPasswordEmpty];
        return;
    }
    
    [[XNUserModule defaultModule] userVerifyLoginPassword:self.loginPasswordTextField.text];
    [self.view showGifLoading];
}

////////////////////
#pragma mark - Protocal
//////////////////////////////////

#pragma mark -
- (void)XNUserModuleVerifyLoginPasswordDidReceive:(XNUserModule *)module
{
    [self.view hideLoading];

    XNModifyGesturePasswordViewController * ctrl = [[XNModifyGesturePasswordViewController alloc]init];
    
    [_UI presentNaviModalViewCtrl:ctrl animated:YES NavigationController:NO completion:nil];
}

- (void)XNUserModuleVerifyLoginPasswordDidFailed:(XNUserModule *)module
{
    [self.view hideLoading];
    
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.errorMsg == nil || [module.retCode.errorMsg isKindOfClass:[NSNull class]] || [module.retCode.errorMsg isEqual:[NSNull null]] || [module.retCode.errorMsg isEqualToString:@""] || [module.retCode.errorMsg isEqualToString:@"success"]) {
        
        [self showCustomWarnViewWithContent:@"密码错误"];
        return;
    }
    
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
