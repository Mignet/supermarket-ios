//
//  XNUserModuleObserver.h
//  FinancialManager
//
//  Created by xnkj on 15/9/25.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

@class XNUserModule;
@protocol XNUserModuleObserver <NSObject>
@optional

//是否注册
- (void)XNUserModuleIsRegDidReceive:(XNUserModule *)module;
- (void)XNUserModuleIsRegDidFailed:(XNUserModule *)module;

//注册
- (void)XNUserModuleRegDidReceive:(XNUserModule *)module;
- (void)XNUserModuleRegDidFailed:(XNUserModule *)module;

//登入操作
- (void)XNUserModuleLoginDidReceive:(XNUserModule *)module;
- (void)XNUserModuleLoginDidFailed:(XNUserModule *)module;

//获取用户信息
- (void)XNUserModuleGetUserInfoDidReceive:(XNUserModule *)module;
- (void)XNUserModuleGetUserInfoDidFailed:(XNUserModule *)module;

//退出登入操作
- (void)XNUserModuleLogoutDidReceive:(XNUserModule *)module;
- (void)XNUserModuleLogoutDidFailed:(XNUserModule *)module;

//获取验证码
- (void)XNUserModuleVCodeDidReceive:(XNUserModule *)module;
- (void)XNUsermoduleVCodeDidFailed:(XNUserModule *)module;

//验证登入密码是否正确
- (void)XNUserModuleVerifyLoginPasswordDidReceive:(XNUserModule *)module;
- (void)XNUserModuleVerifyLoginPasswordDidFailed:(XNUserModule *)module;

//修改登入密码
- (void)XNUserModuleModifyLoginPasswordDidReceive:(XNUserModule *)module;
- (void)XNUserModuleModifyLoginPasswordDidFailed:(XNUserModule *)module;

//找回登入密码
- (void)XNUserModuleResetLoginPasswordDidReceive:(XNUserModule *)module;
- (void)XNUserModuleResetLoginPasswordDidFailed:(XNUserModule *)module;

//验证支付密码是否正确
- (void)XNUserModuleVerifyPayPasswordDidReceive:(XNUserModule *)module;
- (void)XNUserModuleVerifyPayPasswordDidFailed:(XNUserModule *)module;

//修改支付密码
- (void)XNUserModuleModifyPayPasswordDidReceive:(XNUserModule *)module;
- (void)XNUsermoduleModifyPayPasswordDidFailed:(XNUserModule *)module;

//找回支付密码-身份验证
- (void)XNUserModuleVerifyIdentifyDidReceive:(XNUserModule *)module;
- (void)XNUserModuleVerifyIdentifyDidFailed:(XNUserModule *)module;

//找回密码-验证验证码是否正确
- (void)XNUserModuleVerifyVCodeDidReceive:(XNUserModule *)module;
- (void)XNUsermoduleVerifyVCodeDidFaied:(XNUserModule *)module;

//找回支付密码
- (void)XNUserModuleResetPayPasswordDidReceive:(XNUserModule *)module;
- (void)XNUsermoduleResetPayPasswordDidFailed:(XNUserModule *)module;

//验证用户是否已经设置了支付密码
- (void)XNUserModulePayPasswordStatusDidReceive:(XNUserModule *)module;
- (void)XNUserModulePayPasswordStatusDidFailed:(XNUserModule *)module;

//初始化交易密码
- (void)XNUserModuleInitPayPasswordDidReceive:(XNUserModule *)module;
- (void)XNUserModuleInitPayPasswordDidFailed:(XNUserModule *)module;

//手势密码登入-更换token
- (void)XNUserModuleGestureLoginDidReceive:(XNUserModule *)module;
- (void)XNUsermoduleGestureLoginDidFailed:(XNUserModule *)module;

//获取用户信息
- (void)XNUserModuleUserInfoDidReceive:(XNUserModule *)module;
- (void)XNUsermoduleUserInfoDidFailed:(XNUserModule *)module;
@end
