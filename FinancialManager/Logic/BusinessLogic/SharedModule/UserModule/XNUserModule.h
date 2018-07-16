//
//  XNUserModule.h
//  FinancialManager
//
//  Created by xnkj on 15/9/25.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"
#import "XNUserModuleObserver.h"

@class XNUserIsRegMode,XNLoginMode,XNUserInfo;
@interface XNUserModule : AppModuleBase

@property (nonatomic, strong) XNUserIsRegMode              * isRegMode;
@property (nonatomic, strong) XNLoginMode                  * loginMode;
@property (nonatomic, strong) XNUserInfo                   * userMode;

+ (instancetype)defaultModule;

/**
 * 判断用户是否注册
 * params mobile 号码
 * params recommendCode 推荐码/手机号码--可选
 * */
- (void)userIsRegisterWithMobile:(NSString *)phoneNumber recommendCode:(NSString *)recommendCode;

/**
 * 注册
 * params mobile 手机号码
 * params password 登入密码
 * params vcode 验证码-可选
 **/
- (void)userRegisterWithMobile:(NSString *)phoneNumber password:(NSString *)password vcode:(NSString *)vcode;


/**
 * 登入操作功能
 * param phoneNumber 电话号码
 * param password    密码
 * */
- (void)userLoginPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password;

/**
 * 退出登入
 * */
- (void)userLogout;

/**
 * 发送验证码
 * params phone 电话号码
 * params type  获取验证码的类型
 * */
- (void)userSendVCodeWithMobile:(NSString *)phone VCodeType:(VCodeType)type;

/**
 * 手势密码登入-更换token
 * */
- (void)userGestureLogin;

/**
 * 获取用户信息
 **/
- (void)requestUserInfo;
@end
