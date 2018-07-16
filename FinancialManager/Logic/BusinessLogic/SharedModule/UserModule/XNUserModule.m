//
//  XNUserModule.m
//  FinancialManager
//
//  Created by xnkj on 15/9/25.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNUserModule.h"
#import "NSObject+Common.h"

#import "XNUserIsRegMode.h"
#import "XNLoginMode.h"
#import "XNUserInfo.h"

#define USERISREGISTERMETHOD                    @"/user/checkMobile"
#define USERREGISTERMETHOD                    @"/user/register"
#define USERLOGINMETHOD                       @"/user/login"
#define USEREXITMETHOD                        @"/user/logout"
#define USERVCODEMETHOD                       @"/user/sendVcode"

#define USERGESTURELOGINMETHOD                @"/user/gesturePwdLogin"

#define REQUESTUSERINFOMETHOD                 @"/user/getUserInfo"

@implementation XNUserModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 是否注册
- (void)userIsRegisterWithMobile:(NSString *)phoneNumber recommendCode:(NSString *)recommendCode;
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.isRegMode = [XNUserIsRegMode  initUserIsRegObjectWithParams:self.dataDic];
                
                [self notifyObservers:@selector(XNUserModuleIsRegDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUserModuleIsRegDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUserModuleIsRegDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUserModuleIsRegDidFailed:) withObject:self];
    };
    
    NSString * recommendCodeStr = recommendCode;
    if ([NSObject isValidateObj:recommendCode]) {
        
        recommendCodeStr = @"";
    }
    
    NSDictionary * params = @{@"mobile":phoneNumber,@"recommendCode":recommendCodeStr};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERISREGISTERMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 注册
- (void)userRegisterWithMobile:(NSString *)phoneNumber password:(NSString *)password vcode:(NSString *)vcode
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.loginMode = [XNLoginMode  initWithParams:self.dataDic];
                
                [self notifyObservers:@selector(XNUserModuleRegDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUserModuleRegDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUserModuleRegDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUserModuleRegDidFailed:) withObject:self];
    };
    
    NSString * deviceToken = [_LOGIC getValueForKey:XN_DEVICE_TOKEN_TAG];
    
    NSDictionary * params = nil;
    if (deviceToken) {
        
        params = @{@"mobile":phoneNumber,@"password":password,@"vcode":vcode,@"deviceToken":deviceToken};
    }else
        params = @{@"mobile":phoneNumber,@"password":password,@"vcode":vcode};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERREGISTERMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 用户登入操作
- (void)userLoginPhoneNumber:(NSString *)phoneNumber Password:(NSString *)password
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.loginMode = [XNLoginMode  initWithParams:self.dataDic];
                
                [self notifyObservers:@selector(XNUserModuleLoginDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUserModuleLoginDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUserModuleLoginDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUserModuleLoginDidFailed:) withObject:self];
    };
    
    NSString * deviceId = [_LOGIC getDeviceId];
    NSString * deviceModel = [[UIDevice currentDevice] model];
    NSString * systemVersion = [[UIDevice currentDevice] systemVersion];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString * resolution = [NSString stringWithFormat:@"%@x%@",[NSNumber numberWithInt:(int)size.width * scale],[NSNumber numberWithInt:(int)size.height*scale]];
    
    NSString * deviceToken = [_LOGIC getValueForKey:XN_DEVICE_TOKEN_TAG];
    
    NSDictionary * params = nil;
    if (deviceToken) {
        
        params = @{@"mobile":phoneNumber,@"password":password,@"deviceId":deviceId,@"deviceModel":deviceModel,@"systemVersion":systemVersion,@"deviceToken":deviceToken,@"resolution":resolution};
    }else
        params = @{@"mobile":phoneNumber,@"password":password,@"deviceId":deviceId,@"deviceModel":deviceModel,@"systemVersion":systemVersion,@"resolution":resolution};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERLOGINMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 用户退出
- (void)userLogout
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNUserModuleLogoutDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUserModuleLogoutDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUserModuleLogoutDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUserModuleLogoutDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNUserModuleLogoutDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USEREXITMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取验证码
- (void)userSendVCodeWithMobile:(NSString *)phone VCodeType:(VCodeType)type
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNUserModuleVCodeDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUsermoduleVCodeDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUsermoduleVCodeDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUsermoduleVCodeDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
       token = @"";
    }
    
    NSDictionary * params = @{@"token":token,@"mobile":phone,@"type":[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:type]]};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];

    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERVCODEMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 手势密码登入
- (void)userGestureLogin
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNUserModuleGestureLoginDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUsermoduleGestureLoginDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUsermoduleGestureLoginDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUsermoduleGestureLoginDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNUsermoduleGestureLoginDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"method":USERGESTURELOGINMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERGESTURELOGINMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取用户信息
- (void)requestUserInfo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.userMode = [XNUserInfo initUserWithObject:self.dataDic];
                [self notifyObservers:@selector(XNUserModuleUserInfoDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUsermoduleUserInfoDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUsermoduleUserInfoDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUsermoduleUserInfoDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNUsermoduleUserInfoDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:REQUESTUSERINFOMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

@end
