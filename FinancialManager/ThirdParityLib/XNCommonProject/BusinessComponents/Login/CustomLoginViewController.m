//
//  CustomLoginViewController.m
//  FinancialManager
//
//  Created by xnkj on 27/07/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "CustomLoginViewController.h"

#import "UseLoginViewController.h"
#import "UserValidateViewController.h"

@interface CustomLoginViewController ()

@end

@implementation CustomLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 自定义方法
//初始化
- (void)initView
{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
}

//设置登录block
- (void)setLoginOperationBlock:(loginOperation)block
{
    if (block) {
        
        self.block = [block copy];
    }
}

//注册
- (IBAction)clickRegister:(id)sender
{
    if (self.block)
        self.block(1);
    
    [XNUMengHelper umengEvent:@"Q_register"];
    
    UserValidateViewController * regCtrl = [[UserValidateViewController alloc]initWithNibName:@"UserValidateViewController" bundle:nil];
    regCtrl.needNewSwitchViewAnimation = YES;
    
    [[_UI topController] setNeedNewSwitchViewAnimation:YES];
    [_UI pushViewControllerFromRoot:regCtrl hideNavigationBar:NO animated:YES];
}

//登录
- (IBAction)clickLogin:(id)sender
{
    if (self.block)
       self.block(0);
    
    UseLoginViewController * useLoginCtrl = [[UseLoginViewController alloc]initWithNibName:@"UseLoginViewController" bundle:nil];
    useLoginCtrl.showNewAnimation = YES;
    
    [_UI presentNaviModalViewCtrl:useLoginCtrl animated:YES NavigationController:YES hideNavigationBar:YES completion:^{
        
    }];
}

//显示
- (void)show
{
    [_KEY_WINDOW addSubview:self.view];
    
    __weak UIWindow * tmpWindow = _KEY_WINDOW;
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(tmpWindow);
        make.top.equalTo(tmpWindow);
        make.trailing.equalTo(tmpWindow);
        make.height.mas_equalTo(SCREEN_FRAME.size.height - 49);
    }];
}

//隐藏
- (void)hide
{
    [self.view removeFromSuperview];
}
@end
