//
//  SignCalendarModule.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/10.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignCalendarModule.h"
#import "SignCalendarModuleObserver.h"

#import "UserSignModel.h"
#import "UserSignMsgModel.h"
#import "SignStatisticsModel.h"
#import "SignRecordListModel.h"
#import "SignShareModel.h"
#import "SignShareInfoModel.h"
#import "SignCalendarModel.h"
#import "SignBounsTransferModel.h"

#import "InvestStatisticsModel.h"

#define Recommend_Agent_Product      @"/personcenter/recomProductOrg"
#define Recommend_User_Sign          @"/sign/sign/4.5.1"
#define User_Sign_Info               @"/sign/info/4.5.1"
#define User_Sign_Share              @"/sign/share/prize/4.5.1"
#define User_Sign_Share_Info         @"/sign/share/info/4.5.1"
#define User_Sign_Bouns_Transfer     @"/sign/bouns/transfer/4.5.1"
#define User_Sign_Calendar           @"/sign/calendar/4.5.1"
#define User_Sign_Statistics         @"/sign/statistics/4.5.1"
#define User_Sign_Records            @"/sign/records/pageList/4.5.1"

#define Personcenter_InvestCalendarStatistics      @"/personcenter/investCalendarStatistics"
#define Personcenter_RepamentCalendar_Statistics  @"/personcenter/repamentCalendarStatistics"


@implementation SignCalendarModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 产品选择推荐
- (void)recommendWithProductOrgId:(NSString *)productOrgId userIdString:(NSString *)userId withType:(NSString *)type IdType:(NSString *)idType
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                [self notifyObservers:@selector(recommendMemberDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(recommendMemberDidFailed:) withObject:self];
            }
        }
        
        else
        {
            [self notifyObservers:@selector(recommendMemberDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(recommendMemberDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(recommendMemberDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,
                              @"productOrgId":productOrgId,
                              @"userId":userId,
                              @"idType":idType,
                              @"type":type
                              };
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:Recommend_Agent_Product] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 用户签到
- (void)userSign
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.userSignModel = [UserSignModel userSignModelWithParams:self.dataDic];
                [self notifyObservers:@selector(userSignDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(userSignDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(userSignDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(userSignDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(userSignDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:Recommend_User_Sign] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];

}

#pragma mark - 签到信息
- (void)userSignMessage
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.userSignMsgModel = [UserSignMsgModel userSignMsgInfoModelParams:self.dataDic];
                [self notifyObservers:@selector(userSignInfoReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(userSignInfoDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(userSignInfoDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(userSignInfoDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(userSignInfoDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:User_Sign_Info] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 分享
- (void)shareSign
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.signShareModel = [SignShareModel signShareModelWithParams:self.dataDic];
                [self notifyObservers:@selector(userSignShareReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(userSignShareDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(userSignShareDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(userSignShareDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(userSignShareDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:User_Sign_Share] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 分享信息
- (void)shareMessage
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.signShareInfoModel = [SignShareInfoModel signShareInfoModelWithParams:self.dataDic];
                [self notifyObservers:@selector(userSignShareInfoReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(userSignShareInfoDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(userSignShareInfoDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(userSignShareInfoDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(userSignShareInfoDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:User_Sign_Share_Info] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];

}

#pragma mark - 奖励金转账户
- (void)signBounsTransfer
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.signBounsTransferModel = [SignBounsTransferModel signBounsTransferModelWithParams:self.dataDic];
                [self notifyObservers:@selector(userSignBounsTransferReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(userSignBounsTransferDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(userSignBounsTransferDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(userSignBounsTransferDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(userSignBounsTransferDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:User_Sign_Bouns_Transfer] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
    
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 签到日历
- (void)signCalendarSignTime:(NSString *)signTime
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.signCalendarModel = [SignCalendarModel signCalendarModelWithParams:self.dataDic];
                [self notifyObservers:@selector(userSignCalendarReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(userSignCalendarDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(userSignCalendarDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(userSignCalendarDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(userSignCalendarDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{
                              @"token":token,
                              @"signTime":signTime
                              };
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:User_Sign_Calendar] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {

        requestFailureBlock(error);
    }];
}

#pragma mark - 签到统计
- (void)signStatistics
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.signStatisticsModel = [SignStatisticsModel signStatisticsModelWithParams:self.dataDic];
                [self notifyObservers:@selector(userSignStatisticsReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(userSignStatisticsDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(userSignStatisticsDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(userSignStatisticsDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(userSignStatisticsDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:User_Sign_Statistics] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];

}

#pragma mark - 签到记录
- (void)signRecordsPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.signRecordListModel = [SignRecordListModel signRecordListModelWithParams:self.dataDic];
                [self notifyObservers:@selector(userSignRecordsReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(userSignRecordsDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(userSignRecordsDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(userSignRecordsDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(userSignRecordsDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{
                              @"token":token,
                              @"pageIndex":pageIndex,
                              @"pageSize":pageSize
                              };
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:User_Sign_Records] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}

#pragma mark - 4.5.1 交易日历统计
- (void)investCalendarStatisticsInvestMonth:(NSString *)investMonth
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.investStatisticsModel = [InvestStatisticsModel investStatisticsModelWithParams:self.dataDic];
                [self notifyObservers:@selector(investCalendarStatisticsReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(investCalendarStatisticsDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(investCalendarStatisticsDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(investCalendarStatisticsDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(investCalendarStatisticsDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{
                              @"token":token,
                              @"investMonth":investMonth,
                              };
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:Personcenter_InvestCalendarStatistics] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 4.5.1 回款日历统计
- (void)personcenterRepamentCalendarStatistics:(NSString *)rePaymentMonth
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.rebackStatisticsModel = [InvestStatisticsModel investStatisticsModelWithParams:self.dataDic];
                [self notifyObservers:@selector(personcenterRepamentCalendarStatisticsReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(ipersoncenterRepamentCalendarStatisticsDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(ipersoncenterRepamentCalendarStatisticsDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(ipersoncenterRepamentCalendarStatisticsDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(ipersoncenterRepamentCalendarStatisticsDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{
                              @"token":token,
                              @"rePaymentMonth":rePaymentMonth,
                              };
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:Personcenter_RepamentCalendar_Statistics] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];

}


@end
