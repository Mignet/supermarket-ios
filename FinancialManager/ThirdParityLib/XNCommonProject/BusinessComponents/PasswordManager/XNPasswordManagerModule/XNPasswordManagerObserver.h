//
//  XNPasswordManagerObserver.h
//  XNCommonProject
//
//  Created by xnkj on 4/25/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

@class XNPasswordManagerModule;

@protocol XNPasswordManagerObserver <NSObject>
@optional

//初始化交易密码
- (void)XNUserModuleInitPayPasswordDidReceive:(XNPasswordManagerModule *)module;
- (void)XNUserModuleInitPayPasswordDidFailed:(XNPasswordManagerModule *)module;

//验证支付密码是否正确
- (void)XNUserModuleVerifyPayPasswordDidReceive:(XNPasswordManagerModule *)module;
- (void)XNUserModuleVerifyPayPasswordDidFailed:(XNPasswordManagerModule *)module;

//修改支付密码
- (void)XNUserModuleModifyPayPasswordDidReceive:(XNPasswordManagerModule *)module;
- (void)XNUsermoduleModifyPayPasswordDidFailed:(XNPasswordManagerModule *)module;

//重置支付密码-身份验证
- (void)XNUserModuleVerifyIdentifyDidReceive:(XNPasswordManagerModule *)module;
- (void)XNUserModuleVerifyIdentifyDidFailed:(XNPasswordManagerModule *)module;

//重置支付密码-点击手机发送验证码
- (void)XNUserModuleSendVCodeDidReceive:(XNPasswordManagerModule *)module;
- (void)XNUserModuleSendVCodeDidFailed:(XNPasswordManagerModule *)module;

//重置密码-验证验证码是否正确
- (void)XNUserModuleVerifyVCodeDidReceive:(XNPasswordManagerModule *)module;
- (void)XNUsermoduleVerifyVCodeDidFaied:(XNPasswordManagerModule *)module;

//重置支付密码
- (void)XNUserModuleResetPayPasswordDidReceive:(XNPasswordManagerModule *)module;
- (void)XNUsermoduleResetPayPasswordDidFailed:(XNPasswordManagerModule *)module;

//验证用户是否已经设置了支付密码
- (void)XNUserModulePayPasswordStatusDidReceive:(XNPasswordManagerModule *)module;
- (void)XNUserModulePayPasswordStatusDidFailed:(XNPasswordManagerModule *)module;

//修改登入密码
- (void)XNUserModuleModifyLoginPasswordDidReceive:(XNPasswordManagerModule *)module;
- (void)XNUserModuleModifyLoginPasswordDidFailed:(XNPasswordManagerModule *)module;

//找回登入密码
- (void)XNUserModuleResetLoginPasswordDidReceive:(XNPasswordManagerModule *)module;
- (void)XNUserModuleResetLoginPasswordDidFailed:(XNPasswordManagerModule *)module;

//验证登入密码是否正确
- (void)XNUserModuleVerifyLoginPasswordDidReceive:(XNPasswordManagerModule *)module;
- (void)XNUserModuleVerifyLoginPasswordDidFailed:(XNPasswordManagerModule *)module;

@end

