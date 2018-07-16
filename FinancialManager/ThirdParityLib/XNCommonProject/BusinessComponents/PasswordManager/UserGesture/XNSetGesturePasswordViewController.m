//
//  XNSetGesturePasswordViewController.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/27/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "XNSetGesturePasswordViewController.h"

#import "MIFingerPasswordViewController.h"

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
    
    [_UI dismissNaviModalViewCtrlAnimated:YES completion:^{
        
    }];
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
        
        if ([_LOGIC deviceSupportfingerPassword] && [_LOGIC integerForKey:XN_USER_FINGER_PASSWORD_SET] != 1) {
        
            weakSelf(weakSelf)
            [self showFMRecommandViewWithTitle:@"是否启用指纹解锁?" subTitle:@"指纹解锁使用系统自带的Touch ID,更加安全、便捷" subTitleLeftPadding:12 otherSubTitle:@"" okTitle:@"启用" okCompleteBlock:^{
                
                [weakSelf authenticateFingerPassword];
            } cancelTitle:@"取消" cancelCompleteBlock:^{
                
                [weakSelf back:nil];
            }];
        }else
        {
            [self back:nil];
        }
    }
    
    [self.gesturePasswordView resetPasswordStatus];
}

#pragma mark - 验证指纹密码
- (void)authenticateFingerPassword
{
    //检测是否可以使用指纹解锁
    if ([_LOGIC canEvaluatePolicy]) {
        
        weakSelf(weakSelf)
        [_LOGIC evaluatePolicyWithSuccess:^{
            
            [_LOGIC saveInt:1 key:XN_USER_FINGER_PASSWORD_SET];
            
            [weakSelf performSelectorOnMainThread:@selector(showFingerGestureSuccess) withObject:nil waitUntilDone:NO];
            
        } failed:^(NSError *error) {
            
            [weakSelf performSelectorOnMainThread:@selector(showFingerGestureFailed:) withObject:error.userInfo waitUntilDone:NO];
        }];
    }else
    {
        [self back:nil];
        
        MIFingerPasswordViewController * fingerPasswordCtrl = [[MIFingerPasswordViewController alloc]initWithNibName:@"MIFingerPasswordViewController" bundle:nil];
        
        [_UI pushViewControllerFromRoot:fingerPasswordCtrl animated:YES];
    }
}

#pragma mark - 指纹解锁成功
- (void)showFingerGestureSuccess
{
    [self showCustomWarnViewWithContent:@"指纹解锁功能已开启" Completed:^{
        // 解锁成功
        [_UI dismissNaviModalViewCtrlAnimated:YES completion:^{
            
            //发送通知进入对应的页面（接收到远程推送时）
            [[NSNotificationCenter defaultCenter] postNotificationName:XN_REMOTE_NOTIFICATION object:nil];
        }];
        
    }];
}

#pragma mark - 指纹解锁失败提示
- (void)showFingerGestureFailed:(NSDictionary *)userInfo
{
    weakSelf(weakSelf)
    if ([[userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"Application retry limit exceeded."] || [[userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"Biometry is locked out."]) {
        
        [self showFMRecommandViewWithTitle:@"开启失败" subTitle:@"指纹解锁开启失败，以后可以在\"我的\“-\"密码管理\"里面再次开启" subTitleLeftPadding:12.0f otherSubTitle:@"" okTitle:@"知道了" okCompleteBlock:^{
            
            [weakSelf back:nil];
        } cancelTitle:nil cancelCompleteBlock:nil];
        return;
    }else if([[userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"Canceled by user."])
    {
        
        [self showFMRecommandViewWithTitle:@"确定放弃开启指纹解锁?" subTitle:@"如果放弃开启指纹解锁，以后可以在\"我的\“-\"密码管理\"里面再次开启" subTitleLeftPadding:12 otherSubTitle:@"" okTitle:@"确定" okCompleteBlock:^{
            
            [weakSelf back:nil];
        } cancelTitle:@"取消" cancelCompleteBlock:^{
            
            [weakSelf authenticateFingerPassword];
        }];
    }
}


@end
