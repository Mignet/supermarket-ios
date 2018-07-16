//
//  XNUnlockByGestureViewController.m
//  MoneyJar2
//
//  Created by HuangQiSheng on 7/27/15.
//  Copyright (c) 2015 GK. All rights reserved.
//

#import "XNUnlockByGestureViewController.h"

#import "PXAlertView+XNExtenstion.h"

#import "XNDeviceUtil.h"
#import "AppDelegate.h"

#import "XNUserModule.h"
#import "XNUserModuleObserver.h"

@interface XNUnlockByGestureViewController ()

@property (nonatomic, assign) NSInteger retryCount;
@property (nonatomic, strong) UIView  * maskView;//用于遮住手势密码

@end

@implementation XNUnlockByGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.needNewSwitchViewAnimation = NO;
    
    _retryCount = [[_LOGIC getValueForKey:XN_USER_GESTURE_INPUT_ERROR_COUNT_TAG] integerValue];
    self.gesturePasswordView.topTipsLabel.text = [[NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]] convertToSecurityPhoneNumber];
    self.gesturePasswordView.topTipsLabel1.text = @"请绘制图案解锁";
    
    [self.gesturePasswordView.forgotPasswordButton addTarget:self
                                                      action:@selector(forgotGesturePassword:)
                                            forControlEvents:UIControlEventTouchUpInside];
    [self.gesturePasswordView.fingerPasswordButton addTarget:self
                                                      action:@selector(fingerGesturePassword:)
                                            forControlEvents:UIControlEventTouchUpInside];
    [self.gesturePasswordView.loginWithOthersButton addTarget:self
                                                       action:@selector(loginWithOthers:)
                                             forControlEvents:UIControlEventTouchUpInside];
    
    [self.gesturePasswordView layoutLoginGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - XNGesturePasswordViewDelegate
- (void)gesturePasswordDidCreatePassword:(NSString *)password {
    
    NSString *savedPassword =[NSString decryptUseDES:[_LOGIC getValueForKey:[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]];
    if ([password isEqualToString:savedPassword]) {
        
        // 解锁成功
        [_UI dismissNaviModalViewCtrlAnimated:YES completion:^{
            
            [_LOGIC saveValueForKey:XN_USER_GESTURE_INPUT_ERROR_COUNT_TAG Value:@"5"];
            
            //更新token
            [[NSNotificationCenter defaultCenter] postNotificationName:XN_UPDATE_TOKEN_NOTIFICATION object:nil];
            
            //发送通知进入对应的页面（接收到远程推送时）
            [[NSNotificationCenter defaultCenter] postNotificationName:XN_REMOTE_NOTIFICATION object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:XN_USER_LOGIN_SUCCESS_NOTIFICATINO object:nil];
        }];
    } else {
        
       if (password.length < 4) {
            
            self.gesturePasswordView.topTipsLabel1.text = @"至少连接4个点，请重新绘制";
        }else{
            // 解锁失败
            _retryCount--;
            
            [_LOGIC saveValueForKey:XN_USER_GESTURE_INPUT_ERROR_COUNT_TAG Value:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:_retryCount]]];
            if (_retryCount <= 0) {
                
                [_UI dismissNaviModalViewCtrlAnimated:YES completion:^{
                    
                    [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
                }];
                
            } else {
                
                self.gesturePasswordView.topTipsLabel1.text = [NSString stringWithFormat:@"图案密码绘制错误，还可尝试%ld次", (long)_retryCount];
            }
        }
    }
    
    [self.gesturePasswordView resetPasswordStatus];
}

#pragma mark - event
// 点击忘记手势密码
- (void)forgotGesturePassword:(id)sender {
    
    [PXAlertView xn_showAlertWithTitle:@"提示"
                               message:@"忘记手势密码？"
                           cancelTitle:@"取消"
                            otherTitle:@"确定"
                            completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                
                                if (buttonIndex == 1) {
                                    
                                    [_UI dismissNaviModalViewCtrlAnimated:YES completion:^{
                                        
                                        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:[NSNumber numberWithInteger:ForgetGesturePasswordSource]];
                                    }];
                                }
                            }];
    
}

#pragma mark - 指纹解锁
- (void)fingerGesturePassword:(id)sender
{
    [_UI popViewControllerFromRoot:YES];
}

// 点击使用其他账号登录
- (void)loginWithOthers:(id)sender {
    
    
    [PXAlertView xn_showAlertWithTitle:@"提示"
                               message:@"使用其他账号登录？"
                           cancelTitle:@"取消"
                            otherTitle:@"确定"
                            completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                
                                if (buttonIndex == 1) {
                                    
                                    [_UI dismissNaviModalViewCtrlAnimated:YES completion:^{
                                       
                                        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:[NSNumber numberWithInteger:ILoginSourceMax]];
                                    }];
                                }
                            }];
}

@end
