//
//  RankListModule.m
//  FinancialManager
//
//  Created by xnkj on 22/02/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "RankListModule.h"
#import "RankListModuleObserver.h"

#import "MyRankMode.h"
#import "RankListMode.h"
#import "RankCalcBaseDataListMode.h"

#define XN_HOME_MY_PROFIT_RANK_METHOD @"/act/rankList/zyb/myRank"
#define XN_HOME_PROFIT_LIST_RANK_METHOD @"/act/rankList/zyb/rank"

#define XN_HOME_MY_LEADER_PROFIT_RANK_METHOD @"/act/rankList/tdjl/myRank"
#define XN_HOME_MY_LEADER_PROFIT_RANK_LIST_METHOD @"/act/rankList/tdjl/rank"

#define XN_HOME_MY_LEADER_PROFIT_STATUS_METHOD @"/personcenter/partner/leaderProfitStatus"

#define XN_LIECAI_RANK_CALC_BASE_DATA_METHOD @"/crm/cfpcommon/feeCalBaseData"

@implementation RankListModule

//获取我的排名
- (void)requestMyProfitRank
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
            
                self.myProfitRankMode = [MyRankMode initMyRankWithParams:self.dataDic];
                
                [self notifyObservers:@selector(xnRankListModuleGetMyProfitRankDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(xnRankListModuleGetMyProfitRankDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(xnRankListModuleGetMyProfitRankDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(xnRankListModuleGetMyProfitRankDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(xnRankListModuleGetMyProfitRankDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":XN_HOME_MY_PROFIT_RANK_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_HOME_MY_PROFIT_RANK_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//获取排行列表
- (void)requestProfitRankListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.rankListMode = [RankListMode initRankListWithParams:self.dataDic];
                
                [self notifyObservers:@selector(xnRankListModuleGetProfitListRankDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(xnRankListModuleGetProfitListRankDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(xnRankListModuleGetProfitListRankDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(xnRankListModuleGetProfitListRankDidFailed:) withObject:self];
    };
    
//    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
//    if (![NSObject isValidateInitString:token]) {
//        
//        [self notifyObservers:@selector(xnRankListModuleGetMyProfitRankDidFailed:) withObject:self];
//        
//        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
//        return;
//    }
    
    NSDictionary * params = @{@"pageIndex":pageIndex,@"pageSize":pageSize,@"method":XN_HOME_PROFIT_LIST_RANK_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_HOME_PROFIT_LIST_RANK_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//获取我的leader奖励
- (void)requestMyLeaderProfitRank
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.myLeaderRankMode = [MyRankMode initMyRankWithParams:self.dataDic];
                
                [self notifyObservers:@selector(xnRankListModuleGetMyLeaderProfitRankDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(xnRankListModuleGetMyLeaderProfitRankDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(xnRankListModuleGetMyLeaderProfitRankDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(xnRankListModuleGetMyLeaderProfitRankDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(xnRankListModuleGetMyProfitRankDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":XN_HOME_MY_LEADER_PROFIT_RANK_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_HOME_MY_LEADER_PROFIT_RANK_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//获取leader奖励排行
- (void)requestLeaderProfitRankListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.myLeaderListMode = [RankListMode initRankListWithParams:self.dataDic];
                
                [self notifyObservers:@selector(xnRankListModuleGetLeaderProfitListRankDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(xnRankListModuleGetLeaderProfitListRankDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(xnRankListModuleGetLeaderProfitListRankDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(xnRankListModuleGetLeaderProfitListRankDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(xnRankListModuleGetMyProfitRankDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"pageIndex":pageIndex,@"pageSize":pageSize,@"method":XN_HOME_MY_LEADER_PROFIT_RANK_LIST_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_HOME_MY_LEADER_PROFIT_RANK_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//获取理财师leader满足的状态
- (void)requestLeaderProfitStatus
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.cfpLeaderStatus = [self.dataDic objectForKey:XN_HOME_RANK_LEADER_STATUS_CFPSTATUS];
                
                [self notifyObservers:@selector(xnRankListModuleGetLeaderProfitStatusDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(xnRankListModuleGetLeaderProfitStatusDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(xnRankListModuleGetLeaderProfitStatusDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(xnRankListModuleGetLeaderProfitStatusDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(xnRankListModuleGetLeaderProfitStatusDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":XN_HOME_MY_LEADER_PROFIT_STATUS_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_HOME_MY_LEADER_PROFIT_STATUS_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//获取职级计算所需的基本数据
- (void)requestRankCalcBaseDataList
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.rankCalcBaseDataListMode = [RankCalcBaseDataListMode initWithParams:self.dataDic];
                
                [self notifyObservers:@selector(xnRankListModuleGetRankCalcBaseDataListDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(xnRankListModuleGetRankCalcBaseDataListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(xnRankListModuleGetRankCalcBaseDataListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(xnRankListModuleGetRankCalcBaseDataListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token};
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_LIECAI_RANK_CALC_BASE_DATA_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

@end
