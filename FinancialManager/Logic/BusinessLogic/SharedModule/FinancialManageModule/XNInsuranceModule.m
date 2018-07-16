//
//  XNBundModule.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNInsuranceModule.h"
#import "NSObject+Common.h"

#import "XNInsuranceListLinkMode.h"
#import "XNInsuranceDetailMode.h"
#import "XNInsuranceItem.h"
#import "XNInsuranceList.h"
#import "XNInsuranceModuleObserver.h"

#import "InsuranceBannerModel.h"               // 保险首页banner
#import "InsuranceSelectModel.h"               // 甄选保险
#import "XNInsuranceQquestionResultModel.h"    // 首页-保险评测结果

#define XN_INSURANCE_MODULE_SELECTED_INSURANCE_METHOD @"/insurance/qixin/insuranceSift"
#define XN_INSURANCE_MODULE_INSURANCE_LIST_METHOD @"/insurance/qixin/insuranceList"
#define XN_INSURANCE_MODULE_INSURANCE_DETAIL_METHOD @"/insurance/qixin/gotoProductDetail"
#define XN_INSURANCE_MODULE_INSURANCE_LIST_LINK_METHOD @"/insurance/qixin/gotoPersonInsureList"

#define Insurance_Qixin_Insurance_Select @"/insurance/qixin/insuranceSelect"
#define Insurance_Qixin_Insurance_Category @"/insurance/qixin/insuranceCategory"

#define Homepage_Advs @"/homepage/advs"
#define Qixin_QuestionSummary @"/insurance/qixin/questionSummary"

// 是否测评
#define Insurance_Qixin_QueryQquestionResult @"/insurance/qixin/queryQquestionResult"

// 保险评测接口  /api/insurance/qixin/questionSummary
#define Insurance_Qixin_QuestionSummary @"/insurance/qixin/questionSummary"

@implementation XNInsuranceModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 精选保险
- (void)requestSelectedInsurance
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.selectedInsuranceItem = [XNInsuranceItem initInsuranceWithParams:self.dataDic];
                [self notifyObservers:@selector(XNFinancialManagerModuleSelectedInsuranceItemDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleSelectedInsuranceItemDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleSelectedInsuranceItemDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleSelectedInsuranceItemDidFailed:) withObject:self];
    };

    NSDictionary * params = @{};
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_INSURANCE_MODULE_SELECTED_INSURANCE_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

// 保险列表
- (void)requestInsuranceListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize insuranceCategory:(NSString *)insuranceCategory
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.insuranceList = [XNInsuranceList initInsuranceListWithParams:self.dataDic];
                [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceListDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{@"pageIndex":pageIndex,@"pageSize":pageSize,@"method":XN_INSURANCE_MODULE_INSURANCE_LIST_METHOD
                              };
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    if (insuranceCategory.length > 0) {
        [mParams setObject:insuranceCategory forKey:@"insuranceCategory"];
    }
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:mParams];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_INSURANCE_MODULE_INSURANCE_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//保险详情
- (void)requestInsuranceDetaiParamsWithCaseCode:(NSString *)caseCode
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.insuranceDetailMode = [XNInsuranceDetailMode initInsuranceDetailWithParams:self.dataDic];
                [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceDetailDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceDetailDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceDetailDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceDetailDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceDetailDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    NSDictionary * params = @{@"token":token,@"caseCode":caseCode,@"method":XN_INSURANCE_MODULE_INSURANCE_DETAIL_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_INSURANCE_MODULE_INSURANCE_DETAIL_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//保单列表
- (void)requestInsuranceOrderListLink
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.insuranceListLinkMode = [XNInsuranceListLinkMode initInsuranceListLinkWithParams:self.dataDic];
                [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceOrderLinkDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceOrderLinkDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceOrderLinkDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceOrderLinkDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNFinancialManagerModuleInsuranceOrderLinkDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":XN_INSURANCE_MODULE_INSURANCE_LIST_LINK_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_INSURANCE_MODULE_INSURANCE_LIST_LINK_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

/**
 * 列表-甄选保险
 **/
- (void)request_insurance_qixin_insuranceSelect
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.insuranceSelectModel = [InsuranceSelectModel initInsuranceSelectModelWithParams:self.dataDic];
                
//                self.insuranceSelectArr = [NSMutableArray arrayWithCapacity:0];
//                for (NSDictionary *dic in self.dataArr) {
//                    XNInsuranceItem *item = [XNInsuranceItem initInsuranceWithParams:dic];
//                    [self.insuranceSelectArr addObject:item];
//                }
                
                
                [self notifyObservers:@selector(insurance_Qixin_Insurance_SelectDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(insurance_Qixin_Insurance_SelectDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(insurance_Qixin_Insurance_SelectDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        [self convertRetWithError:error];
        [self notifyObservers:@selector(insurance_Qixin_Insurance_SelectDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{@"method":Insurance_Qixin_Insurance_Select};
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:Insurance_Qixin_Insurance_Select] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

/**
 * 保险种类
 */
- (void)request_insurance_category
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                //保存到文件中
                [_LOGIC saveDataArray:[self.dataDic objectForKey:@"datas"] intoFileName:@"insurance_category.plist"];
                
                [self notifyObservers:@selector(insurance_Qixin_Insurance_CategoryDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(insurance_Qixin_Insurance_CategoryDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(insurance_Qixin_Insurance_CategoryDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        [self convertRetWithError:error];
        [self notifyObservers:@selector(insurance_Qixin_Insurance_CategoryDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{@"method":Insurance_Qixin_Insurance_Category};
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:Insurance_Qixin_Insurance_Category] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
    
}

/***
 * 保险banner
 */
- (void)request_insurance_banner
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.bannerModel = [InsuranceBannerModel initInsuranceBannerModelWithObject:self.dataDic];
                
                [self notifyObservers:@selector(request_insurance_banner_DidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(request_insurance_banner_DidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(request_insurance_banner_DidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(request_insurance_banner_DidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{@"appType":@"1",@"advPlacement":@"insurance_banner",@"method":Homepage_Advs};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:Homepage_Advs] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

/***
 *  保险评测接口 （/api/insurance/qixin/questionSummary）
 */
- (void)request_qixin_questionSummary:(NSMutableDictionary *)params
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                [self notifyObservers:@selector(request_Qixin_QuestionSummary_DidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(request_Qixin_QuestionSummary_DidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(request_Qixin_QuestionSummary_DidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(request_Qixin_QuestionSummary_DidFailed:) withObject:self];
    };
    
    [params setObject:@"method" forKey:Qixin_QuestionSummary];
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:Qixin_QuestionSummary] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}

/***
 *  首页-保险评测结果  /api/insurance/qixin/queryQquestionResult
 */
- (void)request_insurance_qixin_queryQquestionResult
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.insuranceResultModel = [XNInsuranceQquestionResultModel createQquestionResultModelWithParams:self.dataDic];
                
                [self notifyObservers:@selector(request_Insurance_Qixin_queryQquestionResultDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(request_Insurance_Qixin_queryQquestionResultDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(request_Insurance_Qixin_queryQquestionResultDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(request_Insurance_Qixin_queryQquestionResultDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        [self notifyObservers:@selector(request_Insurance_Qixin_queryQquestionResultDidFailed:) withObject:self];
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":Insurance_Qixin_QueryQquestionResult};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:Insurance_Qixin_QueryQquestionResult] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

/***
 * 保险评测接口 /api/insurance/qixin/questionSummary
 */
- (void)request_insurance_qixin_questionSummaryParams:(NSDictionary *)params
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
//                self.insuranceResultModel = [XNInsuranceQquestionResultModel createQquestionResultModelWithParams:self.dataDic];
                
                [self notifyObservers:@selector(request_insurance_qixin_questionSummaryParamsDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(request_insurance_qixin_questionSummaryParamsDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(request_insurance_qixin_questionSummaryParamsDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(request_insurance_qixin_questionSummaryParamsDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        [self notifyObservers:@selector(request_insurance_qixin_questionSummaryParamsDidFailed:) withObject:self];
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    [mParams setObject:token forKey:@"token"];
    [mParams setObject:Insurance_Qixin_QuestionSummary forKey:@"method"];
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:mParams];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:Insurance_Qixin_QuestionSummary] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
    
}




@end
