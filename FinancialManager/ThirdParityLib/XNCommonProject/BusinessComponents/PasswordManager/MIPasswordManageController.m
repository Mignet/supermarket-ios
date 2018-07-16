//
//  MIPasswordManageController.m
//  FinancialManager
//
//  Created by xnkj on 15/9/22.
//  Copyright (c) 2015年 xiaoniu. All rights reserved.
//

#import "MIPasswordManageController.h"

#import "MIPasswordManageCell.h"
#import "UserModifyGestureController.h"
#import "MIModifyLoginPwdController.h"
#import "MIModifyPayPwdController.h"
#import "MIInitPayPwdViewController.h"
#import "MIAddBankCardController.h"
#import "MIFingerPasswordViewController.h"

#import "MIMySetMode.h"
#import "XNMyInformationModule.h"

#import "XNUserVerifyPayPwdStatusMode.h"
#import "XNPasswordManagerModule.h"
#import "XNPasswordManagerObserver.h"

#define DEFAULTCELLHEIGHT 49.0f

@interface MIPasswordManageController ()<XNPasswordManagerObserver>

@property (nonatomic, strong) NSArray * passwordContentArray;
@property (nonatomic, strong) NSArray * passwordSubContentArray;

@property (nonatomic, weak) IBOutlet UITableView * listTableView;
@end

@implementation MIPasswordManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.passwordSubContentArray = nil;
    [self.listTableView reloadData];
    [[XNPasswordManagerModule defaultModule] userVerifyExistPayPassword];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[XNPasswordManagerModule defaultModule] removeObserver:self];
}

//////////////////////////
#pragma mark - Custom Method
////////////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.title = @"密码管理";
    
    [self.listTableView setSeparatorColor:[UIColor clearColor]];
    
    [[XNPasswordManagerModule defaultModule] addObserver:self];
    [[XNPasswordManagerModule defaultModule] userVerifyExistPayPassword];
    [self.view showGifLoading];

    [self.listTableView registerNib:[UINib nibWithNibName:@"MIPasswordManageCell" bundle:nil] forCellReuseIdentifier:@"MIPasswordManageCell"];
}

#pragma mark - 计算cell的下标
- (NSInteger)caculateCellIndex:(NSIndexPath *)indexPath
{
    NSInteger index = 0;
    for (NSInteger i = 0; i < indexPath.section; i ++) {
        
        index = index + [[self.passwordContentArray objectAtIndex:index] count];
    }
    
    index = index + indexPath.row;
    
    return index;
}

//////////////////////////////
#pragma mark - protocol Methods
//////////////////////////////////////////

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.passwordContentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.passwordContentArray objectAtIndex:section] count];
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00001;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section < (self.passwordContentArray.count - 1)) {
        
        return 12;
    }
    
    return 0.00001;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = JFZ_COLOR_PAGE_BACKGROUND;
    return view;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DEFAULTCELLHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MIPasswordManageCell * cell = (MIPasswordManageCell *)[tableView dequeueReusableCellWithIdentifier:@"MIPasswordManageCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell updateContent:[[self.passwordContentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] desc:[[self.passwordSubContentArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] AtIndex:indexPath.row TotalIndex:[[self.passwordContentArray objectAtIndex:indexPath.section] count]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self caculateCellIndex:indexPath];
    
    switch (index) {
        case ChangeLoginPasswordType:
        {
            MIModifyLoginPwdController * modifyLoginPwdCtrl = [[MIModifyLoginPwdController alloc]initWithNibName:@"MIModifyLoginPwdController" bundle:nil];
            
            [_UI pushViewControllerFromRoot:modifyLoginPwdCtrl animated:YES];
        }
            break;
        case ChangeTradePasswordType:
        {
            if (![[[XNMyInformationModule defaultModule] settingMode] bundBankCard]) {
                
                MIAddBankCardController * addBankCardCtrl = [[MIAddBankCardController alloc]initWithNibName:@"MIAddBankCardController" bundle:nil];
                
                [_LOGIC saveValueForKey:XN_USER_INIT_PAY_PASSWORD_CONTROLLER Value:@"MIPasswordManageController"];
                
                [_UI pushViewControllerFromRoot:addBankCardCtrl animated:YES];
                
                return;
            }
            
            if (![[[XNPasswordManagerModule defaultModule] userVerifyPayPwdStatusMode] result]) {
                
                MIInitPayPwdViewController * initPayPasswordCtrl = [[MIInitPayPwdViewController alloc]init];
                [_LOGIC saveValueForKey:XN_USER_INIT_PAY_PASSWORD_CONTROLLER Value:@"MIPasswordManageController"];
                
                [_UI pushViewControllerFromRoot:initPayPasswordCtrl animated:YES];
                
                return;
            }
            
            MIModifyPayPwdController  * modifyPayPwdCtrl = [[MIModifyPayPwdController alloc]init];
            
            [_LOGIC saveValueForKey:XN_USER_INIT_PAY_PASSWORD_CONTROLLER Value:@"MIPasswordManageController"];
            
            [_UI pushViewControllerFromRoot:modifyPayPwdCtrl animated:YES];

        }
            break;
        case ChangeGesturePasswordType:
        {
            UserModifyGestureController * setGestureCtrl = [[UserModifyGestureController alloc]initWithNibName:@"UserModifyGestureController" bundle:nil];
            
            [_UI pushViewControllerFromRoot:setGestureCtrl animated:YES];
        }
            break;
        case ChangeFingerPasswordType:
        {
            MIFingerPasswordViewController * fingerPasswordCtrl = [[MIFingerPasswordViewController alloc]initWithNibName:@"MIFingerPasswordViewController" bundle:nil];
            
            [_UI pushViewControllerFromRoot:fingerPasswordCtrl animated:YES];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - 检查是否设置了支付密码
- (void)XNUserModulePayPasswordStatusDidReceive:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
}

- (void)XNUserModulePayPasswordStatusDidFailed:(XNPasswordManagerModule *)module
{
    [self.view hideLoading];
    JCLogError(@"ErrorCode:%@,ErrorMessage:%@",module.retCode.errorCode,module.retCode.errorMsg);
    
    if (module.retCode.detailErrorDic) {
        
        [self showCustomWarnViewWithContent:[[module.retCode.detailErrorDic allValues] firstObject]];
    }else
        [self showCustomWarnViewWithContent:module.retCode.errorMsg];
}

//////////////////
#pragma mark - setter/getter
////////////////////////////////////////

#pragma mark - passwordContentArray
- (NSArray *)passwordContentArray
{
    if (!_passwordContentArray) {
        
        if ([_LOGIC deviceSupportfingerPassword]) {
            
            _passwordContentArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"修改登录密码",@"修改交易密码",nil],[NSArray arrayWithObjects:@"手势密码",@"指纹密码",nil], nil];
        }else
        {
            _passwordContentArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"修改登录密码",@"修改交易密码",nil],[NSArray arrayWithObjects:@"手势密码",nil], nil];
        }
        
    }
    return _passwordContentArray;
}

#pragma mark - passwordSubContentArray
- (NSArray *)passwordSubContentArray
{
    if (!_passwordSubContentArray) {
        
        _passwordSubContentArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"用于登录",@"用于提现",nil],[NSArray arrayWithObjects:@"已开启",[_LOGIC integerForKey:XN_USER_FINGER_PASSWORD_SET]==1?@"已开启":@"未开启",nil], nil];
    }
    return _passwordSubContentArray;
}

@end
