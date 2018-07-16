//
//  XNMessageModule.m
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNActivityModule.h"
#import "NSObject+Common.h"
#import "XNActivityModuleObserver.h"

#import "DoubleElevenMode.h"

#define XN_ACTIVITY_DOUBLEELEVEN_METHOD @"/activity/doubleEleven/hasNewDoubleEleven/4.5.0"

@implementation XNActivityModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

//双11活动
- (void)requestDoubleEleventActivity
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.doubleElevenMode = [DoubleElevenMode initDoubleElevenWithParams:self.dataDic];
                if (self.doubleElevenMode.hasNewDoubleEleven == 1) {
                    
                    [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_DOUBLEELEVEN_ACTIVITY_TAG Value:@"1"];
                    [self notifyObservers:@selector(XNActivityModuleDoubleElevenActivityDidReceive:) withObject:self];
                }else if(!([NSObject isValidateInitString:[_LOGIC getValueForKey:XN_IS_SHOW_HOME_DOUBLEELEVEN_ACTIVITY_TAG]] && [[_LOGIC getValueForKey:XN_IS_SHOW_HOME_DOUBLEELEVEN_ACTIVITY_TAG] integerValue] == 1))
                {
                    [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_DOUBLEELEVEN_ACTIVITY_TAG Value:@"0"];
                }
            }
            else {
                [self notifyObservers:@selector(XNActivityModuleDoubleElevenActivityDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNActivityModuleDoubleElevenActivityDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNActivityModuleDoubleElevenActivityDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateObj:token]) {
        
        token = @"";
    }
    NSDictionary * params = @{@"token":token,@"method":XN_ACTIVITY_DOUBLEELEVEN_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_ACTIVITY_DOUBLEELEVEN_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}

@end
