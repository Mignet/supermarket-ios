//
//  XNBundModule.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNBundModule.h"
#import "XNBundModuleObserver.h"
#import "XNBundListMode.h"
#import "XNBundThirdPageMode.h"
#import "XNBundSelectTypeMode.h"
#import "XNMyBundHoldingStatisticMode.h"
#import "XNMyBundHoldingDetailMode.h"

#define XNBUND_MODULE_FUND_SIFT_METHOD @"/funds/ifast/fundSift"
#define XNBUND_MODULE_IS_REGISTER_METHOD @"/funds/ifast/ifRegister"
#define XNBUND_MODULE_REGISTER_METHOD @"/funds/ifast/quickCustomerMigration"
#define XNBUND_MODULE_GOTO_FUND_DETAIL_METHOD @"/funds/ifast/gotoFundDetail"
#define XNBUND_MODULE_GOTO_FUND_ACCOUNT_METHOD @"/funds/ifast/gotoAccount"
#define XNBUND_MODULE_SELECT_TYPE_METHOD @"/funds/ifast/baseDefined"
#define XNBUND_MODULE_FUND_LIST_METHOD @"/funds/ifast/batchGetFundInfo"
#define XNBUND_MODULE_MYFUND_HOLDINGS_STATISTIC_METHOD @"/funds/ifast/getHoldingsStatistic"
#define XNBUND_MODULE_MYFUND_HOLDING_DETAIL_METHOD @"/funds/ifast/getInvestorHoldingsNew"
#define XNBUND_MODULE_MYFUND_RECORDING_METHOD @"/funds/ifast/getOrderList"

@implementation XNBundModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 精选基金
- (void)requestHotBundList
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.hotBundListMode = [XNBundListMode initWithObject:self.dataDic];
                [self notifyObservers:@selector(XNBundModuleHotBundListDidReceive:) withObject:self];
            }
            else
            {
                if ([self.retCode.ret isEqualToString:@"100006"])
                {
                    NSDictionary *dic = [[jsonData objectForKey:@"errors"] firstObject];
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"msg"], NSLocalizedDescriptionKey, nil];
                    NSError *error = [NSError errorWithDomain:@"error message" code:[[dic objectForKey:@"code"] integerValue] userInfo:userInfo];
                    [self convertRetWithError:error];
                    
                }
                [self notifyObservers:@selector(XNBundModuleHotBundListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNBundModuleHotBundListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNBundModuleHotBundListDidFailed:) withObject:self];
    };
    

    NSDictionary * params = @{@"method":XNBUND_MODULE_FUND_SIFT_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNBUND_MODULE_FUND_SIFT_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 奕丰基金是否注册
- (void)isRegisterBundResult
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.isRegisterBund = [[self.dataDic objectForKey:@"ifRegister"] boolValue];
                [self notifyObservers:@selector(XNBundModuleIsRegisterBundDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNBundModuleIsRegisterBundDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNBundModuleIsRegisterBundDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNBundModuleIsRegisterBundDidFailed:) withObject:self];
    };
    
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNBundModuleIsRegisterBundDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNBUND_MODULE_IS_REGISTER_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 奕丰基金注册
- (void)registerBund
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.bundAccountNumber = [self.dataDic objectForKey:@"accountNumber"];
                [self notifyObservers:@selector(XNBundModuleRegisterBundDidReceive:) withObject:self];
            }
            else
            {
                if ([self.retCode.ret isEqualToString:@"100006"])
                {
                    NSDictionary *dic = [[jsonData objectForKey:@"errors"] firstObject];
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"msg"], NSLocalizedDescriptionKey, nil];
                    NSError *error = [NSError errorWithDomain:@"error message" code:[[dic objectForKey:@"code"] integerValue] userInfo:userInfo];
                    [self convertRetWithError:error];
                    
                }
                [self notifyObservers:@selector(XNBundModuleRegisterBundDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNBundModuleRegisterBundDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNBundModuleRegisterBundDidFailed:) withObject:self];
    };
    
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNBundModuleRegisterBundDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNBUND_MODULE_REGISTER_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 奕丰基金详情页跳转
- (void)gotoFundDetail:(NSString *)productCode
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.bundThirdPageMode = [XNBundThirdPageMode initWithObject:self.dataDic];
                [self notifyObservers:@selector(XNBundModuleRegisterGotoBundDetailDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNBundModuleRegisterGotoBundDetailDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNBundModuleRegisterGotoBundDetailDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNBundModuleRegisterGotoBundDetailDidFailed:) withObject:self];
    };
    
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNBundModuleRegisterGotoBundDetailDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token, @"productCode":productCode};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNBUND_MODULE_GOTO_FUND_DETAIL_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 奕丰基金个人资产页跳转
- (void)gotoFundAccount
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.bundThirdAccountMode = [XNBundThirdPageMode initWithObject:self.dataDic];
                [self notifyObservers:@selector(XNBundModuleGotoBundAccountDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNBundModuleGotoBundAccountDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNBundModuleGotoBundAccountDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNBundModuleGotoBundAccountDidFailed:) withObject:self];
    };
    
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNBundModuleGotoBundAccountDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNBUND_MODULE_GOTO_FUND_ACCOUNT_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 基金列表
- (void)requestBundListWithFundCodes:(NSString *)fundCodes
                       fundHouseCode:(NSString *)fundHouseCode
                            fundType:(NSString *)fundType
                  geographicalSector:(NSString *)geographicalSector
                         isBuyEnable:(NSString *)isBuyEnable
                            isMMFund:(NSString *)isMMFund
                              isQDII:(NSString *)isQDII
                       isRecommended:(NSString *)isRecommended
                           pageIndex:(NSString *)pageIndex
                            pageSize:(NSString *)pageSize
                              period:(NSString *)period
                     queryCodeOrName:(NSString *)queryCodeOrName
                           shortName:(NSString *)shortName
                                sort:(NSString *)sort
                    specializeSector:(NSString *)specializeSector
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.bundListMode = [XNBundListMode initWithObject:self.dataDic];
                [self notifyObservers:@selector(XNBundModuleBundListDidReceive:) withObject:self];
            }
            else
            {
                if ([self.retCode.ret isEqualToString:@"100006"])
                {
                    NSDictionary *dic = [[jsonData objectForKey:@"errors"] firstObject];
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"msg"], NSLocalizedDescriptionKey, nil];
                    NSError *error = [NSError errorWithDomain:@"error message" code:[[dic objectForKey:@"code"] integerValue] userInfo:userInfo];
                    [self convertRetWithError:error];
                    
                }
                [self notifyObservers:@selector(XNBundModuleBundListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNBundModuleBundListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNBundModuleBundListDidFailed:) withObject:self];
    };

    NSDictionary * params = @{@"fundCodes":fundCodes, @"fundHouseCode":fundHouseCode, @"fundType":fundType, @"geographicalSector":geographicalSector, @"isBuyEnable":isBuyEnable, @"isMMFund":isMMFund, @"isQDII":isQDII, @"isRecommended":isRecommended, @"pageIndex":pageIndex, @"pageSize":pageSize, @"period":period, @"queryCodeOrName":queryCodeOrName, @"shortName":shortName, @"sort":sort, @"specializeSector":specializeSector};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNBUND_MODULE_FUND_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 基金类型选择
- (void)requestBundTypeSelector
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                //保存到文件中
                [_LOGIC saveDataDictionary:self.dataDic intoFileName:@"bundTypeList.plist"];

                [self notifyObservers:@selector(XNBundModuleBundTypeSelectorDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNBundModuleBundTypeSelectorDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNBundModuleBundTypeSelectorDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNBundModuleBundTypeSelectorDidFailed:) withObject:self];
    };
    
    
    NSDictionary * params = @{@"method":XNBUND_MODULE_SELECT_TYPE_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNBUND_MODULE_SELECT_TYPE_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 我的基金-持有资产
- (void)requestMyBundHoldingStatistic
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.myBundHoldingStatisticMode = [XNMyBundHoldingStatisticMode initWithObject:self.dataDic];
                [self notifyObservers:@selector(XNBundModuleMyBundHoldingStatisticDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNBundModuleMyBundHoldingStatisticDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNBundModuleMyBundHoldingStatisticDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNBundModuleMyBundHoldingStatisticDidFailed:) withObject:self];
    };
    
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNBundModuleMyBundHoldingStatisticDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNBUND_MODULE_MYFUND_HOLDINGS_STATISTIC_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 我的基金-持有明细
- (void)requestMyFundHoldingDetail:(NSString *)fundCode portfolioId:(NSString *)portfolioId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.myBundHoldingArray = [NSMutableArray array];
                
                XNMyBundHoldingDetailMode *myBundHoldingDetailMode = nil;
                for (NSDictionary *dic in [self.dataDic objectForKey:@"datas"])
                {
                    myBundHoldingDetailMode = [XNMyBundHoldingDetailMode initWithObject:dic];
                    [self.myBundHoldingArray addObject:myBundHoldingDetailMode];
                }

                [self notifyObservers:@selector(XNBundModuleMyBundHoldingDetailDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNBundModuleMyBundHoldingDetailDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNBundModuleMyBundHoldingDetailDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNBundModuleMyBundHoldingDetailDidFailed:) withObject:self];
    };
    
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNBundModuleMyBundHoldingDetailDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token, @"fundCode":fundCode, @"portfolioId":portfolioId};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNBUND_MODULE_MYFUND_HOLDING_DETAIL_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 基金投资记录
- (void)requestMyFundRecordingWithFundCodes:(NSString *)fundCodes
                             merchantNumber:(NSString *)merchantNumber
                               orderDateEnd:(NSString *)orderDateEnd
                             orderDateStart:(NSString *)orderDateStart
                                  pageIndex:(NSString *)pageIndex
                                   pageSize:(NSString *)pageSize
                                portfolioId:(NSString *)portfolioId
                                      rspId:(NSString *)rspId
                          transactionStatus:(NSString *)transactionStatus
                            transactionType:(NSString *)transactionType
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.myBundRecordingMode = [XNBundListMode initWithRecordingObject:self.dataDic];
                [self notifyObservers:@selector(XNBundModuleMyFundRecordingDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNBundModuleMyFundRecordingDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNBundModuleMyFundRecordingDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNBundModuleMyFundRecordingDidFailed:) withObject:self];
    };
    
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNBundModuleMyFundRecordingDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token, @"fundCodes":fundCodes, @"merchantNumber":merchantNumber, @"orderDateEnd":orderDateEnd, @"orderDateStart":orderDateStart, @"pageIndex":pageIndex, @"pageSize":pageSize, @"portfolioId":portfolioId, @"rspId":rspId, @"transactionStatus":transactionStatus, @"transactionType":transactionType};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNBUND_MODULE_MYFUND_RECORDING_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        requestFailureBlock(error);
    }];
    
}

@end
