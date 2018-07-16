//
//  XNPasswordManagerModule.m
//  XNCommonProject
//
//  Created by xnkj on 4/25/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import "XNPasswordManagerModule.h"

#import "XNUserVerifyPayPwdMode.h"
#import "XNUserVerifyIdentifyMode.h"
#import "XNUserVerifyVCodeMode.h"
#import "XNUserVerifyPayPwdStatusMode.h"

#import "XNPasswordManagerObserver.h"

#define USERINITPAYPASSWORDMETHOD             @"/account/initPayPwd"
#define USERVALIDATEPAYPASSWORDMETHOD         @"/account/verifyPayPwd"
#define USERMODIFYPAYPASSWORDMETHOD           @"/account/modifyPayPwd"

#define USERVERIFYIDENTIFYMETHOD              @"/account/verifyIdCard"
#define ACCOUNT_SENDVCODE                     @"/account/sendVcode"
#define USERVERIFYVCODEMETHOD                 @"/account/inputVcode"
#define USERRESETYPAYPASSWORDMETHOD           @"/account/resetPayPwd"

#define USERVERIFYPAYPASSWORDSTATUSMETHOD     @"/account/verifyPayPwdState"

#define USERMODIFYLOGINPASSWORDMETHOD         @"/user/modifyLoginPwd"
#define USERRESETLOGINPASSWORDMETHOD          @"/user/resetLoginPwd"
#define USERVALIDATELOGINPASSWORDMETHOD       @"/user/verifyLoginPwd"



@implementation XNPasswordManagerModule

+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 设置支付密码
- (void)userSetPayPassword:(NSString *)pwd
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNUserModuleInitPayPasswordDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUserModuleInitPayPasswordDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUserModuleInitPayPasswordDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUserModuleInitPayPasswordDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNUserModuleInitPayPasswordDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"pwd":pwd};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERINITPAYPASSWORDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 验证支付密码
- (void)userVerifyPayPassword:(NSString *)payPassword
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.userVerifyPayPwdMode = [XNUserVerifyPayPwdMode initUserVerifyPayPwdWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNUserModuleVerifyPayPasswordDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUserModuleVerifyPayPasswordDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUserModuleVerifyPayPasswordDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUserModuleVerifyPayPasswordDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
         [self notifyObservers:@selector(XNUserModuleVerifyPayPasswordDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"pwd":payPassword};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERVALIDATEPAYPASSWORDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 修改支付密码
- (void)userModifyPayPassword:(NSString *)oldPwd NewPwd:(NSString *)newPwd
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNUserModuleModifyPayPasswordDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUsermoduleModifyPayPasswordDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUsermoduleModifyPayPasswordDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUsermoduleModifyPayPasswordDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNUsermoduleModifyPayPasswordDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"oldPwd":oldPwd,@"newPwd":newPwd};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERMODIFYPAYPASSWORDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 重置支付密码-身份证验证
- (void)userIdentifyVerifyWithName:(NSString *)name IdCard:(NSString *)idCardNo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.userVerifyIdentifyMode = [XNUserVerifyIdentifyMode initUserVerifyIdentifyWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNUserModuleVerifyIdentifyDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUserModuleVerifyIdentifyDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUserModuleVerifyIdentifyDidFailed:) withObject:self];
        }
        
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUserModuleVerifyIdentifyDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
       
         [self notifyObservers:@selector(XNUserModuleVerifyIdentifyDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"name":name,@"idCardNo":idCardNo};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERVERIFYIDENTIFYMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 重置支付密码-点击手机发送验证码
- (void)accountSendVCode
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNUserModuleSendVCodeDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUserModuleSendVCodeDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUserModuleSendVCodeDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUserModuleSendVCodeDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNUserModuleSendVCodeDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:ACCOUNT_SENDVCODE] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 验证重置支付密码-验证码是否正确
- (void)userVerifyVCode:(NSString *)vcode
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.userVerifyVCodeMode = [XNUserVerifyVCodeMode initVerifyVCodeWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNUserModuleVerifyVCodeDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUsermoduleVerifyVCodeDidFaied:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUsermoduleVerifyVCodeDidFaied:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUsermoduleVerifyVCodeDidFaied:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNUsermoduleVerifyVCodeDidFaied:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"vcode":vcode};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERVERIFYVCODEMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 重置支付密码
- (void)userResetPayPassword:(NSString *)pwd
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNUserModuleResetPayPasswordDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUsermoduleResetPayPasswordDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUsermoduleResetPayPasswordDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUsermoduleResetPayPasswordDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNUsermoduleResetPayPasswordDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    NSString * resetPayPwdToken = [[[XNPasswordManagerModule defaultModule] userVerifyVCodeMode] resetPayPwdToken];
    
    NSDictionary * params = @{@"token":token,@"resetPayPwdToken":resetPayPwdToken,@"pwd":pwd};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERRESETYPAYPASSWORDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
    
}

#pragma mark - 是否设置了支付密码
- (void)userVerifyExistPayPassword
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.userVerifyPayPwdStatusMode = [XNUserVerifyPayPwdStatusMode initUserVerifyPayPwdStatusWithObject:self.dataDic];
                [self notifyObservers:@selector(XNUserModulePayPasswordStatusDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUserModulePayPasswordStatusDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUserModulePayPasswordStatusDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUserModulePayPasswordStatusDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNUserModulePayPasswordStatusDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERVERIFYPAYPASSWORDSTATUSMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 修改登入密码
- (void)userModifyLoginPassword:(NSString *)oldPwd NewPwd:(NSString *)newPwd
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNUserModuleModifyLoginPasswordDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUserModuleModifyLoginPasswordDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUserModuleModifyLoginPasswordDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUserModuleModifyLoginPasswordDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNUserModuleModifyLoginPasswordDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"oldPwd":oldPwd,@"newPwd":newPwd};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];

    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERMODIFYLOGINPASSWORDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {

        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 找回登录密码
- (void)userResetLoginPasswordWithPhone:(NSString *)phone VCode:(NSString *)vcode NewPwd:(NSString *)newPwd
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNUserModuleResetLoginPasswordDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUserModuleResetLoginPasswordDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUserModuleResetLoginPasswordDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUserModuleResetLoginPasswordDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{@"mobile":phone,@"vcode":vcode,@"newPwd":newPwd};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];

    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERRESETLOGINPASSWORDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 验证登录密码是否正确
- (void)userVerifyLoginPassword:(NSString *)loginPassword
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                if ([[self.dataDic objectForKey:@"rlt"] boolValue]) {
                    
                    [self notifyObservers:@selector(XNUserModuleVerifyLoginPasswordDidReceive:) withObject:self];
                }else
                {
                    [self notifyObservers:@selector(XNUserModuleVerifyLoginPasswordDidFailed:) withObject:self];
                }
            }
            else {
                [self notifyObservers:@selector(XNUserModuleVerifyLoginPasswordDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUserModuleVerifyLoginPasswordDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUserModuleVerifyLoginPasswordDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNUserModuleVerifyLoginPasswordDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"pwd":loginPassword};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:USERVALIDATELOGINPASSWORDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}
@end
