//
//  XNModifyGesturePasswordViewController.m
//  FinancialManager
//
//  Created by xnkj on 15/10/12.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNModifyGesturePasswordViewController.h"

@interface XNModifyGesturePasswordViewController ()

@property (nonatomic, strong) NSString *password;
@end

@implementation XNModifyGesturePasswordViewController

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
    self.gesturePasswordView.titleLabel.text = @"修改手势密码";
    self.gesturePasswordView.topTipsLabel1.text = @"请绘制解锁图案";
    [self.gesturePasswordView.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.gesturePasswordView layoutChangeGesture];
}

#pragma mark - 返回操作
- (void)back:(id)sender {
    
     [_UI popViewControllerFromRoot:YES];
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
        
        weakSelf(weakSelf)
        [_KEY_WINDOW showCustomWarnViewWithContent:@"手势密码修改成功" Completed:^(){
            
            [weakSelf back:nil];
        }];
    }
    
    [self.gesturePasswordView resetPasswordStatus];
}

@end
