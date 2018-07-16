//
//  XNMessageModule.m
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNMessageModule.h"
#import "NSObject+Common.h"

#import "XNCommonMsgListMode.h"
#import "XNPrivateMsgListMode.h"

#import "XNMessageModuleObserver.h"

#define XNCOMMONMESSAGELISTMETHOD @"/msg/bulletin/pageList"
#define XNPRIVATEMESSAGELISTMETHOD @"/msg/person/pageList"
#define XNPRIVATEMESSGAEDELETEMETHOD @"/msg/person/del"
#define XNUNREADMSGCOUNTMETHOD @"/msg/person/unreadCount"
#define XNANNOUNCEMSGDETAILMETHOD @"/msg/notice/detail"
#define XNANNOUNCEREADALLMESSAGEMETHOD @"/msg/notice/allReaded"

@implementation XNMessageModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 公共消息列表
- (void)requestCommonMsgListAtPageIndex:(NSString *)pageIndex PageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.commonMsgListMode = [XNCommonMsgListMode initCommonMsgListWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNMessageModuleCommonMsgListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMessageModuleCommonMsgListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMessageModuleCommonMsgListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMessageModuleCommonMsgListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMessageModuleCommonMsgListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }


    
    NSDictionary * params = @{@"token":token,@"pageIndex":pageIndex,@"pageSize":pageSize};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNCOMMONMESSAGELISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取私人消息列表
- (void)requestPrivateMsgListAtPageIndex:(NSString *)pageIndex PageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.privateMsgListMode = [XNPrivateMsgListMode initPrivateMsgListWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNMessageModulePrivateMsgListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMessageModulePrivateMsgListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMessageModulePrivateMsgListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMessageModulePrivateMsgListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMessageModulePrivateMsgListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }


    
    NSDictionary * params = @{@"token":token,@"pageIndex":pageIndex,@"pageSize":pageSize};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNPRIVATEMESSAGELISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 删除个人消息
- (void)deletePrivateMsgForMsgId:(NSString *)msgId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNMessageModulePrivateMsgDeleDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMessageModulePrivateMsgDeleDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMessageModulePrivateMsgDeleDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMessageModulePrivateMsgDeleDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMessageModulePrivateMsgDeleDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"msgIds":msgId};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNPRIVATEMESSGAEDELETEMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取未读消息
- (void)getUnReadMsgCount
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.unReadMsgMode = self.dataDic;
                [self notifyObservers:@selector(XNMessageModuleUnreadMsgCountDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMessageModuleUnreadMsgCountDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMessageModuleUnreadMsgCountDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMessageModuleUnreadMsgCountDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
         [self notifyObservers:@selector(XNMessageModuleUnreadMsgCountDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }


    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNUNREADMSGCOUNTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取消息详情
- (void)getMsgDetailWithMsgId:(NSString *)msgId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNMessageModuleAnnounceMsgDetailDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMessageModuleAnnounceMsgDetailDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMessageModuleAnnounceMsgDetailDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMessageModuleAnnounceMsgDetailDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMessageModuleAnnounceMsgDetailDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"msgId":msgId,@"method":XNANNOUNCEMSGDETAILMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNANNOUNCEMSGDETAILMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 
- (void)readAllMsg
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNMessageModuleReadAllMsgDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMessageModuleReadAllMsgDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMessageModuleReadAllMsgDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMessageModuleReadAllMsgDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMessageModuleReadAllMsgDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    
    NSDictionary * params = @{@"token":token,@"method":XNANNOUNCEREADALLMESSAGEMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNANNOUNCEREADALLMESSAGEMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

@end
