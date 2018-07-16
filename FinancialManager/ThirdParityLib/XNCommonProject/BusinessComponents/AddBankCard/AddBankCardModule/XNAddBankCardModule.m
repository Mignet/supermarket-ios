//
//  XNAccountModule.m
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNAddBankCardModule.h"
#import "NSObject+common.h"

#import "XNOpenBankMode.h"
#import "XNBankCardMode.h"
#import "XNGetUserBindBankCardInfoMode.h"

#import "XNAddBankCardModuleObserver.h"

#define ACCOUNTBINDBANKCARDMETHOD  @"/account/addBankCard"
#define ACCOUNTGETBANKCARDINFOMETHOD  @"/account/queryAllBank"
#define ACCOUNTGETBINDBANKCARDMETHOD  @"/account/getUserBindCard"
#define ACCOUNTUPDATEBANKCARDIMAGEMETHOD @"/kareco/bankcardReco"
#define ACCOUNTUPDATEIDCARDIMAGEMETHOD @"/kareco/idcardReco"

@implementation XNAddBankCardModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 获取银行卡信息
- (void)getAllBankInfo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                NSMutableArray * arr = [NSMutableArray array];
                XNOpenBankMode * mode = nil;
                for (NSDictionary * dic in [self.dataDic objectForKey:XN_ACCOUNT_MYACCOUNT_DETAIL_TYPE_DATA]) {
                    
                    mode = [XNOpenBankMode initOpenBankModeWithObject:dic];
                    [arr addObject:mode];
                }
                self.openBankListArray = arr;
                
                [self notifyObservers:@selector(XNAccountModuleGetOpenBankInfoDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAccountModuleGetOpenBankInfoDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAccountModuleGetOpenBankInfoDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAccountModuleGetOpenBankInfoDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNAccountModuleGetOpenBankInfoDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":ACCOUNTGETBANKCARDINFOMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:ACCOUNTGETBANKCARDINFOMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//绑卡
- (void)addBankCardWithBankCardNumber:(NSString *)bankCard idCard:(NSString *)idCard mobile:(NSString *)mobile userName:(NSString *)userName
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.bankCardMode = [XNBankCardMode initBankCardModeWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNAccountModuleBankBankCardDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAccountModuleBankBankCardDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAccountModuleBankBankCardDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAccountModuleBankBankCardDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNAccountModuleBankBankCardDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"bankCard":bankCard,@"idCard":idCard,@"mobile":mobile,@"userName":userName,@"method":ACCOUNTBINDBANKCARDMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:ACCOUNTBINDBANKCARDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 查看用户绑卡信息
- (void)getUserBindBankCardInfo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.userBindCardInfoMode = [XNGetUserBindBankCardInfoMode initUserBindBankCardInfoWithObject:self.dataDic];
                [self notifyObservers:@selector(XNAccountModuleGetBindBankCardInfoDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAccountModuleGetBindBankCardInfoDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAccountModuleGetBindBankCardInfoDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAccountModuleGetBindBankCardInfoDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNAccountModuleGetBindBankCardInfoDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"method":ACCOUNTGETBINDBANKCARDMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:ACCOUNTGETBINDBANKCARDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}


//上传银行卡图片
- (void)uploadBankCardImage:(UIImage *)bankCardImag
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.bankCardNumberStr = self.dataDic[@"bankCard"];
                [self notifyObservers:@selector(XNAccountModuleUploadBankCardImageDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAccountModuleUploadBankCardImageDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAccountModuleUploadBankCardImageDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAccountModuleUploadBankCardImageDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNAccountModuleUploadBankCardImageDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",@"https://market.toobei.com/rest",ACCOUNTUPDATEBANKCARDIMAGEMETHOD];
    [[EnvSwitchManager sharedClient] POST:url parameters:signedParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        NSData * imageData = UIImagePNGRepresentation(bankCardImag);

        [formData appendPartWithFileData:imageData name:@"file" fileName:@"bankCard" mimeType:@"image/png"];

    } success:^(AFHTTPRequestOperation *operation, id responseObject) {

        requestSuccessBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        requestFailureBlock(error);
    }];
}

/**
 * 上传身份证图片
 * params idCardImage 图片实体
 **/
- (void)uploadIdCardImage:(UIImage *)idCardImage
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.idNumberStr = self.dataDic[@"idCard"];
                self.userNameStr = self.dataDic[@"name"];
                [self notifyObservers:@selector(XNAccountModuleUploadIdCardImageDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAccountModuleUploadIdCardImageDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAccountModuleUploadIdCardImageDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAccountModuleUploadIdCardImageDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNAccountModuleUploadBankCardImageDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",@"https://market.toobei.com/rest",ACCOUNTUPDATEIDCARDIMAGEMETHOD];
    [[EnvSwitchManager sharedClient] POST:url parameters:signedParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSData * imageData = UIImagePNGRepresentation(idCardImage);
        
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"bankCard" mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}
@end
