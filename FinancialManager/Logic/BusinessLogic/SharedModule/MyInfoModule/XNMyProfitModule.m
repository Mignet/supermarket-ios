//
//  XNMyProfitModule.m
//  FinancialManager
//
//  Created by xnkj on 22/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNMyProfitModule.h"
#import "XNMyProfitModuleObserver.h"

#import "XNMIMyProfitDetailListMode.h"
#import "MIAccountBalanceMode.h"
#import "MIAccountBalanceDetailMode.h"
#import "MIAccountBalanceCommonMode.h"
#import "MIInvestRecordListMode.h"

#define XNMYINFOMYPROFITLISTMETHOD @"/profit/cfplannerProfitItem"
#define XN_MYINFO_ACCOUNT_BALANCE_DETAIL_METHOD  @"/account/getLieCaiBalance"
#define XN_MYINFO_ACCOUNT_BALANCE_DETAIL_LIST_METHOD  @"/account/queryIncomeAndOutDetail"
#define XN_MY_LEADER_REWARD_METHOD @"/personcenter/partner/leaderProfit"
#define XN_MY_LEADER_REWARD_DIRECT_CFG_METHOD @"/personcenter/partner/directCfpPageList"
#define XN_MY_LEADER_REWARD_CONTRIBUTE_METHOD @"/personcenter/partner/contribuPageList"
#define XN_MYINFO_INVEST_RECORD_LIST_METHOD @"/productinvestrecord/myInvestrecord"

/***交易记录 **/
#define XN_MYINFO_INVEST_RECORD_LIST_INVEST_RECORD @"/personcenter/investCalendar"

// 保险记录
#define XN_MYINFO_INVEST_RECORD_LIST_Insurance_RECORD  @"/personcenter/insuranceCalendar"

@implementation XNMyProfitModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 获取我的收益明细
- (void)getMyProfitDetailListForTimeType:(NSString *)timeType time:(NSString *)time profitTypeId:(NSString *)typeId pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.myProfitListMode = [XNMIMyProfitDetailListMode initMyProfitDetailListWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNMyInfoModuleMyProfitListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleMyProfitListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleMyProfitListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleMyProfitListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleMyProfitListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"dateType":timeType,@"date":time,@"profitType":typeId,@"pageIndex":pageIndex,@"pageSize":pageSize,@"method":XNMYINFOMYPROFITLISTMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFOMYPROFITLISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 资金明细－账户余额
- (void)getAccountBalanceDetail
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.accountBalanceDetailMode = [MIAccountBalanceDetailMode initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNMyProfitModuleAccountBalanceDetailDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyProfitModuleAccountBalanceDetailDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyProfitModuleAccountBalanceDetailDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyProfitModuleAccountBalanceDetailDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNMyProfitModuleAccountBalanceDetailDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_ACCOUNT_BALANCE_DETAIL_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 资金明细－收支明细
- (void)getAccountBalanceDetailList:(NSString *)pageIndex pageSize:(NSString *)pageSize typeValue:(NSString *)typeValue
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                switch ([typeValue integerValue]) {
                    case 0: //全部明细
                        self.totalDetailListMode = [MIAccountBalanceCommonMode initWithAccountBalanceDetailListObject:self.dataDic];
                        self.totalDetailListMode.type = typeValue;
                        break;
                    case 1: //收入明细
                        self.incomeDetailListMode = [MIAccountBalanceCommonMode initWithAccountBalanceDetailListObject:self.dataDic];
                        self.incomeDetailListMode.type = typeValue;
                        
                        break;
                    case 2: //支出明细
                        self.outDetailListMode = [MIAccountBalanceCommonMode initWithAccountBalanceDetailListObject:self.dataDic];
                        self.outDetailListMode.type = typeValue;
                        
                        break;
                        
                    default:
                        break;
                }
                
                self.accountBalanceDetailListMode = [MIAccountBalanceCommonMode initWithAccountBalanceDetailListObject:self.dataDic];
                self.accountBalanceDetailListMode.type = typeValue;
                [self notifyObservers:@selector(XNMyProfitModuleAccountBalanceDetailListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyProfitModuleAccountBalanceDetailListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyProfitModuleAccountBalanceDetailListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyProfitModuleAccountBalanceDetailListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        
        [self notifyObservers:@selector(XNMyProfitModuleAccountBalanceDetailListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"pageIndex":pageIndex,@"pageSize":pageSize,@"typeValue":typeValue};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_ACCOUNT_BALANCE_DETAIL_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 我的投资记录
- (void)getInvestRecordList:(NSString *)investType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.investingProductsListMode = nil;
                self.expiredProductsListMode = nil;
                if ([investType integerValue] == 0)
                {
                    //在投产品
                    self.investingProductsListMode = [MIInvestRecordListMode initWithObject:self.dataDic];
                }
                else
                {
                    //已到期产品
                    self.expiredProductsListMode = [MIInvestRecordListMode initWithObject:self.dataDic];
                }
                
                [self notifyObservers:@selector(XNMyProfitModuleInvestRecordListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyProfitModuleInvestRecordListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyProfitModuleInvestRecordListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyProfitModuleInvestRecordListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        
        [self notifyObservers:@selector(XNMyProfitModuleInvestRecordListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"investType":investType,@"pageIndex":pageIndex,@"pageSize":pageSize};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_INVEST_RECORD_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 投资记录（4.5.0）
- (void)requestInvestRecordListPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize investTime:(NSString *)investTime
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.investRecordListMode = [MIInvestRecordListMode initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(requestInvestRecordListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(requestInvestRecordListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(requestInvestRecordListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(requestInvestRecordListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        
        [self notifyObservers:@selector(requestInvestRecordListDidFailed:) withObject:self];
        
//        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        
        return;
    }
    
    NSDictionary * params = @{@"token":token,
                              @"pageIndex":pageIndex,
                              @"pageSize":pageSize,
                              @"method":XN_MYINFO_INVEST_RECORD_LIST_INVEST_RECORD
                              };
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_INVEST_RECORD_LIST_INVEST_RECORD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];

}

// 接口名称 4.5.0 交易记录 (具体某一天)
- (void)requestDayInvestRecordListPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize investTime:(NSString *)investTime
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.dayInvestRecordListMode = [MIInvestRecordListMode initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(requestDayInvestRecordListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(requestDayInvestRecordListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(requestDayInvestRecordListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(requestDayInvestRecordListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        
        [self notifyObservers:@selector(requestDayInvestRecordListDidFailed:) withObject:self];
        
        //        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        
        return;
    }
    
    NSDictionary * params = @{@"token":token,
                              @"pageIndex":pageIndex,
                              @"pageSize":pageSize,
                              @"method":XN_MYINFO_INVEST_RECORD_LIST_INVEST_RECORD,
                              @"investTime":investTime
                              };
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_INVEST_RECORD_LIST_INVEST_RECORD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];

}

#pragma mark - 保险记录（4.5.1）
- (void)requestInsuranceRecordListPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize investTime:(NSString *)investTime
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.insuranceRecordListMode = [MIInvestRecordListMode initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(requestInsuranceRecordListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(requestInsuranceRecordListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(requestInsuranceRecordListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(requestInsuranceRecordListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        
        [self notifyObservers:@selector(requestInsuranceRecordListDidFailed:) withObject:self];
        
        //        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        
        return;
    }
    
    NSDictionary * params = @{@"token":token,
                              @"pageIndex":pageIndex,
                              @"pageSize":pageSize,
                              @"method":XN_MYINFO_INVEST_RECORD_LIST_INVEST_RECORD
                              };
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_INVEST_RECORD_LIST_Insurance_RECORD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];

}

#pragma mark - 保险记录 (4.5.1) 具体某一天
- (void)requestDayInsuranceRecordListPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize investTime:(NSString *)investTime
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.dayInsuranceRecordListMode = [MIInvestRecordListMode initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(requestDayInsuranceRecordListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(requestDayInsuranceRecordListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(requestDayInsuranceRecordListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(requestDayInsuranceRecordListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        
        [self notifyObservers:@selector(requestDayInsuranceRecordListDidFailed:) withObject:self];
        
        //        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        
        return;
    }
    
    NSDictionary * params = @{@"token":token,
                              @"pageIndex":pageIndex,
                              @"pageSize":pageSize,
                              @"method":XN_MYINFO_INVEST_RECORD_LIST_INVEST_RECORD,
                              @"investTime":investTime
                              };
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_INVEST_RECORD_LIST_Insurance_RECORD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}





@end
