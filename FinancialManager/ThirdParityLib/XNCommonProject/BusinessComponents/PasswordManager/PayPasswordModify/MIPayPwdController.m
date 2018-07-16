//
//  MIPayPwdController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/13.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIPayPwdController.h"

@interface MIPayPwdController ()

@end

@implementation MIPayPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////
#pragma mark - Custome Method
///////////////////////////////////////////

#pragma makr - 初始化
- (void)initView
{
    [self.view setBackgroundColor:JFZ_COLOR_PAGE_BACKGROUND];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.inputPwdView];
    
    weakSelf(weakSelf)
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(weakSelf.view.mas_leading).offset(12);
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(12);
        make.height.mas_equalTo(15);
    }];
    
    [self.inputPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(weakSelf.view.mas_leading);
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(32);
        make.width.mas_equalTo(SCREEN_FRAME.size.width);
        make.height.mas_equalTo((3.0 *(SCREEN_FRAME.size.width - 24)) / 17);
    }];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

///////////////////
#pragma mark - setter/getter
//////////////////////////////////////

#pragma mark - titleLabel
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return _titleLabel;
}

#pragma mark - inputPwdView
- (SetPasswordView *)inputPwdView
{
    if (!_inputPwdView) {
        
        _inputPwdView = [[SetPasswordView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, (3.0 *(SCREEN_FRAME.size.width - 24)) / 17) cellSize:CGSizeMake((SCREEN_FRAME.size.width - 24) / 6, (3.0 *(SCREEN_FRAME.size.width - 24)) / 17)];
    }
    return _inputPwdView;
}

@end
