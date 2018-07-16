//
//  XNPasswordManagerModule.h
//  XNCommonProject
//
//  Created by xnkj on 4/25/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import "AppModuleBase.h"

@class XNUserVerifyPayPwdMode,XNUserVerifyIdentifyMode,XNUserVerifyVCodeMode,XNUserVerifyPayPwdStatusMode;
@interface XNPasswordManagerModule : AppModuleBase

@property (nonatomic, strong) XNUserVerifyIdentifyMode     * userVerifyIdentifyMode;
@property (nonatomic, strong) XNUserVerifyPayPwdMode       * userVerifyPayPwdMode;
@property (nonatomic, strong) XNUserVerifyVCodeMode        * userVerifyVCodeMode;
@property (nonatomic, strong) XNUserVerifyPayPwdStatusMode * userVerifyPayPwdStatusMode;

+ (instancetype)defaultModule;

/**
 * 第一次设置交易密码
 * params pwd 交易密码
 * */
- (void)userSetPayPassword:(NSString *)pwd;

/**
 * 验证支付密码是否正确
 * params payPassword   支付密码
 * */
- (void)userVerifyPayPassword:(NSString *)payPassword;

/**
 * 修改支付密码
 * params oldPwd  原始密码
 * params newPwd  新密码
 * */
- (void)userModifyPayPassword:(NSString *)oldPwd NewPwd:(NSString *)newPwd;

/**
 * 重置支付密码--身份验证
 * params name 用户名字
 * params idCard 身份证号
 * */
- (void)userIdentifyVerifyWithName:(NSString *)name IdCard:(NSString *)idCardNo;

/**
 * 重置支付密码-点击手机发送验证码
 */
- (void)accountSendVCode;

/**
 * 重置支付密码--校验码验证
 * params vcode 验证码
 * */
- (void)userVerifyVCode:(NSString *)vcode;

/**
 * 重置支付密码
 * params pwd 新的支付密码
 * */
- (void)userResetPayPassword:(NSString *)pwd;

/**
 * 检查用户是否设置了支付密码
 * */
- (void)userVerifyExistPayPassword;

/**
 * 修改登入密码
 * params oldPwd  原始密码
 * params newPwd  新密码
 * */
- (void)userModifyLoginPassword:(NSString *)oldPwd NewPwd:(NSString *)newPwd;

/**
 * 找回登入密码
 * params phone 电话号码
 * params vcode 对应的验证码
 * params newPwd 新的登入密码
 * */
- (void)userResetLoginPasswordWithPhone:(NSString *)phone VCode:(NSString *)vcode NewPwd:(NSString *)newPwd;

/**
 * 验证登入密码是否正确
 * params password 密码
 * */
- (void)userVerifyLoginPassword:(NSString *)loginPassword;


@end
