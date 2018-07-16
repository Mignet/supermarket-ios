//
//  UIView+TradePasswordView.m
//  Lhlc
//
//  Created by ancye.Xie on 5/11/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "TradePasswordViewController.h"
//#import "PayPasswordView.h"

@interface TradePasswordViewController()

@property (nonatomic, strong) NSString *titleName;

@end

@implementation TradePasswordViewController

- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        
        self.titleName = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

- (void)initView
{
    self.view.backgroundColor = WHITE_COLOR;
    self.view.size = CGSizeMake(SCREEN_FRAME.size.width, 120);
    self.view.layer.borderColor = COMMON_LINE_COLOR.CGColor;
    self.view.layer.borderWidth = 0.5;
    
    UIView *headerView = [UIView new];
    
    UIButton *cancelButton = [UIButton new];
    [cancelButton setImage:[UIImage imageNamed:@"cancel_icon"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = _titleName;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = BLACK_COLOR;
    
    UIButton *forgetPwdButton = [UIButton new];
    [forgetPwdButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPwdButton setTitleColor:COMMON_BLUE_WORD forState:UIControlStateNormal];
    forgetPwdButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [forgetPwdButton addTarget:self action:@selector(forgetPwdAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:headerView];
    [headerView addSubview:cancelButton];
    [headerView addSubview:titleLabel];
    [headerView addSubview:forgetPwdButton];
    
    UIView *pwdView = [UIView new];
    pwdView.layer.borderWidth = 0.5;
    pwdView.layer.borderColor = COMMON_LINE_COLOR.CGColor;
    
    _passwordView = [[PayPasswordView alloc] initWithPayPasswordViewWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, 50) CellSize:CGSizeMake((SCREEN_FRAME.size.width - COMMON_PADDING * 1.5) / 6.0, 50)];
    _passwordView.backgroundColor = WHITE_COLOR;
 
    [self.view addSubview:pwdView];
    [pwdView addSubview:_passwordView];
    
    weakSelf(weakSelf)
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top);
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(45);
    }];
    
    __weak UIView *weakHeaderView = headerView;
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakHeaderView.mas_centerY);
        make.left.mas_equalTo(COMMON_PADDING);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakHeaderView.mas_centerX);
        make.centerY.mas_equalTo(weakHeaderView.mas_centerY);
        make.width.mas_equalTo(SCREEN_FRAME.size.width / 2);
    }];
    
    [forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakHeaderView.mas_centerY);
        make.right.mas_equalTo(weakHeaderView.mas_right).offset(- COMMON_PADDING);
        make.height.mas_equalTo(15);
    }];
    
    
    [pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakHeaderView.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo(75);
    }];
    
    __weak UIView *weakPwdView = pwdView;
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakPwdView.mas_centerY);
        make.left.equalTo(weakPwdView.mas_left);
        make.right.equalTo(weakPwdView.mas_right);
        make.height.mas_equalTo(50);
    }];
    
}

#pragma mark -刷新值
- (void)refreshAmount
{
    [self.passwordView clearUpPassword];
    self.passwordView.delegate = self.delegate;
    [self.passwordView showKeyboard];
    
}

#pragma mark - 忘记密码
- (void)forgetPwdAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(passwordInputControllerDidForgetPassword)]) {
        
        [self.delegate passwordInputControllerDidForgetPassword];
    }
}

#pragma mark - 退出
- (void)cancelAction:(id)sender
{
    [self.view setHidden:YES];
    [self.view endEditing:YES];
}


@end
