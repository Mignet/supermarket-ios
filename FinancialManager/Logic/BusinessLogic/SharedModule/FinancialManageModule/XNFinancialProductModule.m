//
//  XNFinancialProductModule.m
//  FinancialManager
//
//  Created by xnkj on 20/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNFinancialProductModule.h"

#import "XNFMProductCategoryListMode.h"
#import "XNFinancialProductModuleObserver.h"
#import "XNRecommendListMode.h"

#define FMPRODUCTCATEGORYLISTMETHOD      @"/product/productPageList/4.0"
#define FMPRODUCTSELECTEDCOUNTTMETHOD      @"/product/productPageListStatistics/4.0"
#define FMPRODUCTRECOMMENDMETHOD         @"/product/recommend"
#define FMPRODUCTRECANCELCOMMENDMETHOD   @"/product/cancelRecommend"
#define FMPRODUCTSHAREDMETHOD            @"/product/share"
#define FM_RECOMMEND_PRODUCT_LIST_METHOD @"/product/recommendChooseList"
#define FM_RECOMMEND_PRODUCT_METHOD @"/product/recommendByChoose"
#define FM_RECOMMEND_PLATFORM_LIST_METHOD @"/platfrom/recommendChooseList"
#define FM_RECOMMEND_PLATFORM_METHOD @"/platfrom/recommendByChoose"
#define FM_HOT_RECOMMEND_PRDOCUT_METHOD @"/product/hotRecommendProductListTop/2.0.1"
#define FM_SELECT_PRODUCT_LIST_METHOD @"/product/selectedProductsList/4.1.1"

@implementation XNFinancialProductModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark -  产品-产品分类列表
- (void)fmProductListWithYearFlowRate:(NSString *)flowRate
                             deadLine:(NSString *)deadlineValue
                             userType:(NSString *)userType
                                 sort:(NSString *)sort
                                order:(NSString *)order
                            pageIndex:(NSString *)pageIndex
                             pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.productListMode = [XNFMProductCategoryListMode initProductCategoryListWithParams:self.dataDic];
                [self notifyObservers:@selector(XNFinancialManagerModuleProductStatisticCategoryListDidReceive:) withObject:self];
            }
            else {
                
                [self notifyObservers:@selector(XNFinancialManagerModuleProductStatisticCategoryListDidFailed:) withObject:self];
            }
        } else {
            
            [self notifyObservers:@selector(XNFinancialManagerModuleProductStatisticCategoryListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleProductStatisticCategoryListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token,@"flowRate":flowRate,@"deadlineValue":deadlineValue,@"ifRookie":userType,@"sort":sort,@"order":order,@"pageIndex":pageIndex,@"pageSize":pageSize,@"method":FMPRODUCTCATEGORYLISTMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FMPRODUCTCATEGORYLISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取搜索条件对应产品的数量
- (void)fmProductSelectedCountWithYearFlowRate:(NSString *)flowRate
                                      deadLine:(NSString *)deadlineValue
                                      ifRookie:(NSString *)userType
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.selectedConditionProductCount = [NSString stringWithFormat:@"%@",[self.dataDic objectForKey:XNFMPRODUCTSELECTEDCOUNT]];
                
                [self notifyObservers:@selector(xnFinancialManagerModuleConditionProductCountDidReceive:) withObject:self];
            }
            else {
                
                [self notifyObservers:@selector(XNFinancialManagerModuleConditionSelectedProductCountDidFailed:) withObject:self];
            }
        } else {
            
            [self notifyObservers:@selector(XNFinancialManagerModuleConditionSelectedProductCountDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleConditionSelectedProductCountDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{@"flowRate":flowRate,@"deadlineValue":deadlineValue,@"ifRookie":userType,@"method":FMPRODUCTSELECTEDCOUNTTMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FMPRODUCTSELECTEDCOUNTTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 设置推荐理财师
- (void)fmSetRecommendProductWithProductId:(NSString *)productId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNFinancialManagerModuleSetProductRecommendDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNFinancialManagerModuleSetProductRecommendDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNFinancialManagerModuleSetProductRecommendDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleSetProductRecommendDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNFinancialManagerModuleSetProductRecommendDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"productId":productId,@"method":FMPRODUCTRECOMMENDMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FMPRODUCTRECOMMENDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 取消推荐
- (void)fmCancelRecommendProductWithProductId:(NSString *)productId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNFinancialManagerModuleCancelProductRecommendDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNFinancialManagerModuleCancelProductRecommendDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNFinancialManagerModuleCancelProductRecommendDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleCancelProductRecommendDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNFinancialManagerModuleCancelProductRecommendDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"productId":productId,@"method":FMPRODUCTRECANCELCOMMENDMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FMPRODUCTRECANCELCOMMENDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 产品分享信息
- (void)fmGetSharedProductInfoWithProductId:(NSString *)productId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.productSharedMode = [self.dataDic objectForKey:XNSHAREDCONTENT];
                [self notifyObservers:@selector(XNFinancialManagerModuleProductSharedDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNFinancialManagerModuleProductSharedDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNFinancialManagerModuleProductSharedDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleProductSharedDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNFinancialManagerModuleProductSharedDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    
    NSDictionary * params = @{@"token":token,@"productId":productId,@"method":FMPRODUCTSHAREDMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FMPRODUCTSHAREDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 产品推荐选择列表
- (void)fmRecommendProductWithProductId:(NSString *)productId searchValue:(NSString *)searchValue
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.recommendProductListMode = [XNRecommendListMode initWithObject:self.dataDic];
                [self notifyObservers:@selector(XNFinancialManagerModuleRecommendProductDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleRecommendProductDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleRecommendProductDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleRecommendProductDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNFinancialManagerModuleRecommendProductDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"productId":productId,@"searchValue":searchValue};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FM_RECOMMEND_PRODUCT_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 产品选择推荐
- (void)fmRecommendWithProductId:(NSString *)productId userIdString:(NSString *)userIdString
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleRecommendDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleRecommendDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleRecommendDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleRecommendDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNFinancialManagerModuleRecommendDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"productId":productId, @"userIdString":userIdString};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FM_RECOMMEND_PRODUCT_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 机构推荐选择列表
- (void)fmRecommendAgentWithAgentCode:(NSString *)agentCode searchValue:(NSString *)searchValue
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.recommendAgentListMode = [XNRecommendListMode initWithObject:self.dataDic];
                [self notifyObservers:@selector(XNFinancialManagerModuleRecommendAgentListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleRecommendAgentListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleRecommendAgentListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleRecommendAgentListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNFinancialManagerModuleRecommendAgentListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"orgCode":agentCode,@"searchValue":searchValue};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FM_RECOMMEND_PLATFORM_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 机构选择推荐
- (void)fmRecommendWithAgentCode:(NSString *)agentCode userIdString:(NSString *)userIdString
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleRecommendAgentDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleRecommendAgentDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleRecommendAgentDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleRecommendAgentDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNFinancialManagerModuleRecommendAgentDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"orgCode":agentCode, @"userIdString":userIdString};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FM_RECOMMEND_PLATFORM_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 热门推荐产品
- (void)fmRequestHotRecommendProductListTop
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.hotRecommendListMode = [XNFMProductCategoryListMode initProductCategoryListWithParams:self.dataDic];
                [self notifyObservers:@selector(XNFinancialManagermoduleHotRecommendTopDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleHotRecommendTopDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleHotRecommendTopDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleHotRecommendTopDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNFinancialManagerModuleHotRecommendTopDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token ,@"method":FM_HOT_RECOMMEND_PRDOCUT_METHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FM_HOT_RECOMMEND_PRDOCUT_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 精选产品分类列表
- (void)fmRequestSelectProductListWithCateId:(NSString *)cateId pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                if ([cateId integerValue] == 1)
                {
                    self.shortTermSelectProductsListMode = [XNFMProductCategoryListMode initProductCategoryListWithParams:self.dataDic];
                }
                else
                {
                    self.longTermSelectProductsListMode = [XNFMProductCategoryListMode initProductCategoryListWithParams:self.dataDic];
                }
                
                
                [self notifyObservers:@selector(XNFinancialProductModuleSelectProductListDidReceive:) withObject:self];
            }
            else
            {
                
                [self notifyObservers:@selector(XNFinancialProductModuleSelectProductListDidFailed:) withObject:self];
            }
        } else {
            
            [self notifyObservers:@selector(XNFinancialProductModuleSelectProductListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialProductModuleSelectProductListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token,@"cateId":cateId,@"pageIndex":pageIndex,@"pageSize":pageSize};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FM_SELECT_PRODUCT_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

@end
