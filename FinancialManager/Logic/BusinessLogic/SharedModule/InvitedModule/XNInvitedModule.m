//
//  XNInvitedModule.m
//  FinancialManager
//
//  Created by xnkj on 15/12/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNInvitedModule.h" 
#import "NSObject+Common.h"
#import "XNInvitedModuleObserver.h"

#import "XNInvitedCustomerMode.h"
#import "XNInvitedContactMode.h"
#import "XNInviedListStaticsMode.h"
#import "XNInvitedListMode.h"
#import "XNInvitedCountMode.h"

#define XN_INVITED_UPGRADE_CUSTOMER_PREVIEW_CONTENT @"content"

#define XNINVITED_INVITED_CUSTOMER_METHOD @"/invitation/customer/homepage"
#define XNINVITED_INVITED_CONTACT_METHOD @"/invitation/maillist"
#define XNINVITED_INVITED_CONTACT_RECALL_METHOD @"invitation.maillist.callback"
#define XNINVITED_INVITED_CONTACT_REINVITED_METHOD @"invitation.maillist.resend"
#define XNINVITED_INVITED_UPGRADE_CUSTOMER_METHOD @"invitation.cfp.upgrade.pageList"
#define XNINVITED_INVITED_UPGRADE_CUSTOMER_PREVIEW_METHOD @"invitation.cfp.upgrade.preview"
#define XNINVITED_INVITED_UPGRADE_CUSTOMER_SEND_METHOD @"invitation.cfp.upgrade.send"
#define XNINVITED_INVITED_WX @"invitation.cfp.wechat.creatCode"
#define XNINVITED_INVITED_WX_RESEND_METHOD @"invitation.cfp.wechat.resend"
#define XNINVITED_STATISTICS_METHOD @"invitation.cfp.rcList.statistics"
#define XNINVITED_INVITED_LIST_METHOD @"invitation.cfp.rcList.pageList"

#define XNINVITED_INVITED_HOME_METHOD @"/invitation/cfp/homepage"

#define XN_MYINF_INVITED_CFG_STATICSTIC_METHOD @"/invitation/cfplannerRecordStatistics"

#define XN_MYINF_INVITED_CFG_LIST_METHOD @"/user/invitationCfp"
#define XN_MYINFO_INVITED_CUSTOMER_LIST_METHOD @"/user/invitationInvestor"

#define XN_MYINFO_INVITED_CUSTOMER_STATISTIC_METHOD @"/invitation/customerRecordStatistics"
#define XN_INVITED_COUNT_METHOD @"/user/invitationNum"

@implementation XNInvitedModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 邀请客户请求
- (void)xnInvitedCustomerRequest
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.invitedCustomerMode = [XNInvitedCustomerMode initInvitedCustomerWithObject:self.dataDic];
                
                [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerDidReceiver:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":XNINVITED_INVITED_CUSTOMER_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNINVITED_INVITED_CUSTOMER_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 通讯录邀请
- (void)xnInvitedContactListRequestWithMobile:(NSArray *)mobiles userNames:(NSArray *)userNames type:(NSString *)type
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.invitedContactMode = [XNInvitedContactMode initInvitedContactWithParams:self.dataDic];
                
                [self notifyObservers:@selector(xnInvitedModuleInvitedContactDidReceiver:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(xnInvitedModuleInvitedContactDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(xnInvitedModuleInvitedContactDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(xnInvitedModuleInvitedContactDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateObj:token]) {
        
        token = @"";
    }
    
    NSString * mobileStr = @"";
    for (NSString * mobile in mobiles) {
        
        mobileStr = [mobileStr stringByAppendingFormat:@",%@",mobile];
    }
    mobileStr = [[mobileStr stringByReplacingOccurrencesOfString:@" " withString:@""] substringFromIndex:1];
    
    NSString * userNameStr = @"";
    for (NSString * userName in userNames) {
        
        userNameStr = [userNameStr stringByAppendingFormat:@",%@",userName];
    }
    userNameStr = [[userNameStr stringByReplacingOccurrencesOfString:@" " withString:@""] substringFromIndex:1];
    
    NSDictionary * params = @{@"token":token,@"type":type,@"mobiles":mobileStr,@"names":userNameStr,@"method":XNINVITED_INVITED_CONTACT_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNINVITED_INVITED_CONTACT_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 通讯录邀请-回调
- (void)xnNotificationContactInvitedStatusForMobiles:(NSArray *)mobiles
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(xnInvitedModuleInvitedContactNotificationDidReceiver:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(xnInvitedModuleInvitedContactNotificationDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(xnInvitedModuleInvitedContactNotificationDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(xnInvitedModuleInvitedContactNotificationDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(xnInvitedModuleInvitedContactNotificationDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSString * mobileStr = @"";
    for (NSString * mobile in mobiles) {
        
        mobileStr = [mobileStr stringByAppendingFormat:@",%@",[mobile stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    }
    mobileStr = [[mobileStr stringByReplacingOccurrencesOfString:@" " withString:@""] substringFromIndex:1];
    
    NSDictionary * params = @{@"token":token,@"mobiles":mobileStr,@"method":XNINVITED_INVITED_CONTACT_RECALL_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNINVITED_INVITED_CONTACT_RECALL_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 邀请首页
- (void)xnInvitedHomeInfo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.invitedHomeInfoMode = self.dataDic;
                [self notifyObservers:@selector(xnInvitedModuleInvitedHomePageDidReceiver:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(xnInvitedModuleInvitedHomePageDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(xnInvitedModuleInvitedHomePageDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(xnInvitedModuleInvitedHomePageDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(xnInvitedModuleInvitedHomePageDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":XNINVITED_INVITED_HOME_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNINVITED_INVITED_HOME_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 邀请理财师统计
- (void)requestCfgStatistic
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.regiteredCfgCount = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"regiteredCount"]];
                
                [self notifyObservers:@selector(XNInvitedModuleInvitedCfgCountDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNInvitedModuleInvitedCfgCountDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNInvitedModuleInvitedCfgCountDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNInvitedModuleInvitedCfgCountDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNInvitedModuleInvitedCfgCountDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":XN_MYINF_INVITED_CFG_STATICSTIC_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINF_INVITED_CFG_STATICSTIC_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 邀请理财师列表
- (void)requestCfgInvitedListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.invitedCfgListMode = [XNInvitedListMode initInvitedListWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNInvitedModuleInvitedCfgListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNInvitedModuleInvitedCfgListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNInvitedModuleInvitedCfgListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNInvitedModuleInvitedCfgListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNInvitedModuleInvitedCfgListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"pageIndex":pageIndex,@"pageSize":pageSize,@"method":XN_MYINF_INVITED_CFG_LIST_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINF_INVITED_CFG_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

/**
 * 邀请客户记录统计
 **/
- (void)requestInvistCustomerStatistic
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.invitedCustomerStatisticMode = [XNInviedListStaticsMode initInvitedListStaticsWithObject:self.dataDic];
                
                [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerStatisticsDidReceiver:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerStatisticsDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerStatisticsDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerStatisticsDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerStatisticsDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":XN_MYINFO_INVITED_CUSTOMER_STATISTIC_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_INVITED_CUSTOMER_STATISTIC_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

/**
 * 邀请客户列表
 **/
- (void)requestInvistCustomerListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.invitedCustomerListMode = [XNInvitedListMode initInvitedListWithObject:self.dataDic];
                
                [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerListDidReceiver:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(xnInvitedModuleInvitedCustomerListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"pageIndex":pageIndex,@"pageSize":pageSize,@"method":XN_MYINFO_INVITED_CUSTOMER_LIST_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_INVITED_CUSTOMER_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 邀请记录-统计数量
- (void)requestInvitedCount
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.invitedCountMode = [XNInvitedCountMode initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNInvitedModuleInvitedCountDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNInvitedModuleInvitedCountDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNInvitedModuleInvitedCountDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNInvitedModuleInvitedCountDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNInvitedModuleInvitedCountDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_INVITED_COUNT_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

@end
