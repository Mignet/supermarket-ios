//
//  MyInfoModule.m
//  FinancialManager
//
//  Created by xnkj on 15/10/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNRelatedModule.h"
#import "NSObject+Common.h"
#import "XNRelatedModuleObserver.h"

#import "XNMsgNoDisturbMode.h"

#define XNMYINFOFEEDBACKCONENTMETHOD @"/app/suggestion"
#define XN_MYINFO_QUERY_MSG_PUSH @"/msg/queryMsgPushSet"
#define XN_MYINFO_SET_MSG_PUSH @"/msg/setMsgPush"

@implementation XNRelatedModule


#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 意见反馈
- (void)feedBackContent:(NSString *)content
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNMyInfoModuleFeedBackDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleFeedBackDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleFeedBackDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleFeedBackDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleFeedBackDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }


    
    NSDictionary * params = @{@"token":token,@"content":content};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFOFEEDBACKCONENTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 查询消息免打扰设置信息消息
- (void)requestMsgNoDisturb
{
    //网络请求成功
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.msgNoDisturbMode = [XNMsgNoDisturbMode initWithParams:self.dataDic];
                NSLog(@"获取消息免打扰设置:%@", self.dataDic);
                [self notifyObservers:@selector(XNMyInfoModuleQueryMsgNoDisturbDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyInfoModuleQueryMsgNoDisturbDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyInfoModuleQueryMsgNoDisturbDidFailed:) withObject:self];
        }
    };
    
    //网络请求失败
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error) {
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleQueryMsgNoDisturbDidFailed:) withObject:self];
    };
    
    /*
     进行网络请求
     */
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleQueryMsgNoDisturbDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParam = [_LOGIC getSignParams:params];
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_QUERY_MSG_PUSH]
                          parameters:signedParam
                             success:^(id operation, id responseObject) {
                                 
                                 requestSuccessBlock(responseObject);
                                 
                             } failure:^(id operation, NSError *error) {
                                 requestFailureBlock(error);
                             }];
    
}

#pragma mark - 消息免打扰设置
- (void)setMsgNoDisturbWithPlatformFlag:(NSString *)platformflag
{
    //网络请求成功
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                
                [self notifyObservers:@selector(XNMyInfoModuleSetMsgNoDisturbDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyInfoModuleSetMsgNoDisturbDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyInfoModuleSetMsgNoDisturbDidFailed:) withObject:self];
        }
    };
    
    //网络请求失败
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error) {
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleSetMsgNoDisturbDidFailed:) withObject:self];
    };
    
    /*
     进行网络请求
     */
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleSetMsgNoDisturbDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token, @"issendNotice":platformflag};
    
    NSDictionary *signedParam = [_LOGIC getSignParams:params];
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_SET_MSG_PUSH]
                          parameters:signedParam
                             success:^(id operation, id responseObject) {
                                 
                                 requestSuccessBlock(responseObject);
                                 
                             } failure:^(id operation, NSError *error) {
                                 requestFailureBlock(error);
                             }];
}

@end
