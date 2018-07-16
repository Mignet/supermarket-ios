//
//  XNAccountModule.m
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNAccountModule.h"
#import "NSObject+common.h"

#import "XNMyAccountInfoMode.h"
#import "XNAccountRecordListMode.h"
#import "XNMyAccountDetailType.h"

#import "XNAccountModuleObserver.h"

#define ACCOUNTMYACCOUNTINFOMETHOD    @"/account/myaccount"
#define ACCOUNTMYACCOUNTDETAILTYPEMETHOD @"/account/queryAccountType"
#define ACCOUNTMYACCOUNTDETAILLISTMETHOD @"/account/myaccountDetail/pageList"

@implementation XNAccountModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 我的账户信息
- (void)getMyAccountInfo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.myAccountMode = [XNMyAccountInfoMode initMyAccountWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNAccountModuleMyAccountInfoDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAccountModuleMyAccountInfoDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAccountModuleMyAccountInfoDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAccountModuleMyAccountInfoDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
         [self notifyObservers:@selector(XNAccountModuleMyAccountInfoDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":ACCOUNTMYACCOUNTINFOMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:ACCOUNTMYACCOUNTINFOMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取账户详情列表
- (void)getMyAccountDetailListForTypeId:(NSString *)typeId PageIndex:(NSString *)pageIndex PageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.myAccountRecordListMode = [XNAccountRecordListMode initAccountRecordListWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNAccountModuleMyAccountDetailListDidReveive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNAccountModuleMyAccountDetailListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNAccountModuleMyAccountDetailListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNAccountModuleMyAccountDetailListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        
        [self notifyObservers:@selector(XNAccountModuleMyAccountDetailListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"typeValue":typeId,@"pageIndex":pageIndex,@"pageSize":pageSize,@"method":ACCOUNTMYACCOUNTDETAILLISTMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:ACCOUNTMYACCOUNTDETAILLISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}
@end
