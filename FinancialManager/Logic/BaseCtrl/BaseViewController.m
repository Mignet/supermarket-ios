//
//  BaseViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/17.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationItem+Extension.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.needNewSwitchViewAnimation = NO;
        [self setSwitchToHomePage:YES];//登录后跳转首页
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.needNewSwitchViewAnimation = NO;
        [self setSwitchToHomePage:YES];//登录后跳转首页
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //打开umeng
    [XNUMengHelper beginLogPageView:self.class];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //结束umeng
    [XNUMengHelper endLogPageView:self.class];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self setSwitchToHomePage:YES];
}

///////////////////////////////////
#pragma mark - Custom Methods
/////////////////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initData
{
    [self.navigationItem addBackButtonItemWithTarget:self action:@selector(clickBack:)];
    self.navigationSeperatorLineStatus = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFrontFromBack) name:XN_APP_FROM_BACK_TO_FRONT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackFromFront) name:XN_APP_FROM_FRONT_TO_BACK object:nil];

//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    [self.view addGestureRecognizer:self.panGesture];
}

#pragma mark - 键盘将要显示
- (void)keyboardShow:(NSNotification *)notifx
{

}

#pragma mark - 键盘将要消失
- (void)keyboardHide:(NSNotification *)notif
{
    
}

#pragma mark - 退出键盘
- (void)exitKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 退出键盘相关其他的操作
- (void)exitKeyboardToOtherOperation
{
    
}

#pragma mark - 返回操作
- (void)clickBack:(UIButton *)sender
{
    [_UI popViewControllerFromRoot:YES];
}

#pragma mark - 从后台进入前台
- (void)enterFrontFromBack
{
    [self viewWillAppear:YES];
    [self viewDidAppear:YES];
}

#pragma mark - 从前台到后台
- (void)enterBackFromFront
{
    [self viewDidDisappear:YES];
}

///////////////////////
#pragma mark - Protocal
/////////////////////////////////

#pragma mark - 退出键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self exitKeyboard];
    [self exitKeyboardToOtherOperation];
    
    return YES;
}
@end
