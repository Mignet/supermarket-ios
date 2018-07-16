//
//  DeportMoneyModule.m
//  XNCommonProject
//
//  Created by xnkj on 4/26/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import "DeportMoneyModule.h"

#import "XNWithDrawBankCardInfoMode.h"
#import "XNMyAccountTotalDeportMode.h"
#import "XNMyAccountDeportRecordListMode.h"

#import "DeportMoneyModuleObserver.h"


#define ACCOUNTMYACCOUNTUSERSETTLEINFOMETHOD @"/account/getWithdrawBankCard"
#define ACCOUNTMYACCOUNTWITHDRAWREQUESTMETHOD @"/account/userWithdrawRequest"
#define ACCOUNTMYACCOUNTPROVINCEQUESTMETHOD @"/account/queryAllProvince"
#define ACCOUNTMYACCOUNTPCITYMETHOD @"/account/queryCityByProvince"

#define ACCOUNTMYACCOUNTTOTALDEPORTMETHOD @"/account/getWithdrawSummary"
#define ACCOUNTMYACCOUNTDEPORTLISTMETHOD @"/account/queryWithdrawLog"

@implementation DeportMoneyModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 查询银行卡信息
- (void)requestBindBankCardInfo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.userBindBankCardinfoDictionary = self.dataDic;
                [self notifyObservers:@selector(XNAccountModuleUserBindBankCardInfoDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAccountModuleUserBindBankCardInfoDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAccountModuleUserBindBankCardInfoDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAccountModuleUserBindBankCardInfoDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNAccountModuleUserBindBankCardInfoDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"method":ACCOUNTMYACCOUNTUSERSETTLEINFOMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:ACCOUNTMYACCOUNTUSERSETTLEINFOMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 查询省份
- (void)requestProvinceInfo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.provinceInfoArray = [self.dataDic objectForKey:@"datas"];
                [self notifyObservers:@selector(XNAccountModuleGetProvinceDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAccountModuleGetProvinceDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAccountModuleGetProvinceDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAccountModuleGetProvinceDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNAccountModuleGetProvinceDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":ACCOUNTMYACCOUNTPROVINCEQUESTMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:ACCOUNTMYACCOUNTPROVINCEQUESTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 查询省份对应的城市
- (void)requestCityInfoWithProvinceCode:(NSString *)proviceCode
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.cityInfoArray = [self.dataDic objectForKey:@"datas"];
                [self notifyObservers:@selector(XNAccountModuleGetCityDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAccountModuleGetCityDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAccountModuleGetCityDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAccountModuleGetCityDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNAccountModuleGetCityDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"provinceId":proviceCode,@"method":ACCOUNTMYACCOUNTPCITYMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:ACCOUNTMYACCOUNTPCITYMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark -提款
- (void)requestWithDrawWithBankCard:(NSString *)bankCard bankName:(NSString *)bankName city:(NSString *)city kaiHuHang:(NSString *)kaihuhang amount:(NSString *)amount
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNAccountModuleWithDrawDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAccountModuleWithDrawDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAccountModuleWithDrawDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAccountModuleWithDrawDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNAccountModuleWithDrawDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"bankCard":bankCard,@"bankName":bankName,@"city":city,@"kaihuhang":kaihuhang,@"amount":amount,@"method":ACCOUNTMYACCOUNTWITHDRAWREQUESTMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:ACCOUNTMYACCOUNTWITHDRAWREQUESTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}


#pragma mark - 获取提现累计值
- (void)getMyAccountTotalDeportMoney
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.myAccountTotalDeportMode = [XNMyAccountTotalDeportMode initTotalDeportWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNAccountModuleMyAccountTotalDeportDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAccountModuleMyAccountTotalDeportDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAccountModuleMyAccountTotalDeportDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAccountModuleMyAccountTotalDeportDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNAccountModuleMyAccountTotalDeportDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":ACCOUNTMYACCOUNTTOTALDEPORTMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:ACCOUNTMYACCOUNTTOTALDEPORTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取提现明细
- (void)getmyAccountDeportRecordListAtIndex:(NSString *)pageIndex PageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.myAccountDeportRecordListMode = [XNMyAccountDeportRecordListMode initMyAccountRecordListWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNAccountModuleMyAccountDeportListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAccountModuleMyAccountDeportListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAccountModuleMyAccountDeportListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAccountModuleMyAccountDeportListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNAccountModuleMyAccountDeportListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    
    NSDictionary * params = @{@"token":token,@"pageIndex":pageIndex,@"pageSize":pageSize,@"method":ACCOUNTMYACCOUNTDEPORTLISTMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:ACCOUNTMYACCOUNTDEPORTLISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

@end
