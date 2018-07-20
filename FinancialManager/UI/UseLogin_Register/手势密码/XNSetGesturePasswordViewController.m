//
//  XNSetGesturePasswordViewController.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/27/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "XNSetGesturePasswordViewController.h"
#import "XNKeychainUtil.h"

@interface XNSetGesturePasswordViewController ()

@property (nonatomic, strong) NSString *password;
@end

@implementation XNSetGesturePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//////////////////
#pragma mark - Custom Methods
////////////////////////////////

#pragma mark - 初始化操作
- (void)initView
{
    self.gesturePasswordView.titleLabel.text = @"设置手势密码";
    self.gesturePasswordView.topTipsLabel1.text = @"为了您的账户安全，请绘制解锁图案";
    
    [self.gesturePasswordView layoutSetGesutre];
}

#pragma mark - 返回操作
- (void)back:(id)sender {
    
    [_UI dismissNaviModalViewCtrlAnimated:YES];
}

//////////////////
#pragma mark - Protocal
////////////////////////////////////////////////

#pragma mark - XNGesturePasswordViewDelegate
- (void)gesturePasswordDidCreatePassword:(NSString *)password {
    

    if (password.length < 4) {
        
        self.gesturePasswordView.topTipsLabel1.text = @"至少连接4个点，请重新绘制";
    } else if (!_password) {
        
        _password = password;
        self.gesturePasswordView.topTipsLabel1.text = @"请重复上次绘制的图案";
    } else if (![_password isEqualToString:password]) {
        
        _password = nil;
        self.gesturePasswordView.topTipsLabel1.text = @"两次绘制不一致，请重新绘制";
    } else {
        
        // 设置成功
        [_LOGIC saveValueForKey:[_LOGIC getValueForKey:XN_USER_MOBILE_TAG] Value:[NSString encryptUseDES:_password]];
        
        JCLogError(@"key:%@,value:%@",[_LOGIC getValueForKey:XN_USER_MOBILE_TAG],[NSString encryptUseDES:_password]);
        
        [self back:nil];
    }
    
    [self.gesturePasswordView resetPasswordStatus];
}

@end
