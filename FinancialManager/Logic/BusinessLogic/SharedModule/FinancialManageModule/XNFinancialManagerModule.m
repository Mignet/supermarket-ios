//
//  XNFinancialManagerModule.m
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNFinancialManagerModule.h"
#import "NSObject+Common.h"


#import "XNFMProductCategoryListMode.h"
#import "XNFMProductListMode.h"
#import "XNFMProductListItemMode.h"
#import "XNFMProductDetailMode.h"
#import "XNFMProfitCaculateMode.h"
#import "XNFinancialManagerModuleObserver.h"
#import "XNFMAgentListMode.h"
#import "XNFMAgentSelectConditionMode.h"
#import "XNFMAgentDetailMode.h"
#import "XNFMProductCategoryStatisticMode.h"
#import "XNFMAgentListItemMode.h"

/*** 产品可用红包模型 **/
#import "ProductRedPacketModel.h"

#define FMCURRENTPRODUCTLISTMETHOD       @"/product/productPageList/4.0"
#define FMPRODUCTCATEGORYSTATICMETHOD    @"/product/productClassifyStatistics/2.0.1"
#define FMPRODUCTCATEGORYLISTMETHOD      @"/product/productClassifyPageList/2.0.1"

#define FMPRODUCTCACULATECOMISSIONMETHOD @"/product/profitCalculate"
#define FM_AGENT_LIST_METHOD   @"/platfrom/orgPageList/4.0"
#define FMPRODUCTRECOMMENDMETHOD         @"/product/recommend"
#define FMPRODUCTRECANCELCOMMENDMETHOD   @"/product/cancelRecommend"
#define FMPRODUCTSHAREDMETHOD            @"/product/share"
#define FM_AGENT_LIST_SELECT_CONDITION_METHOD   @"/platfrom/platformHead"
#define FM_AGENT_DETAIL_METHOD @"/platfrom/detail"
#define FM_AGENT_SALE_PRODUCTS @"/platfrom/platformSaleProducts"

#define FMPRODUCTTAGLISTMETHOD       @"/product/productTypeList/2.0.1"
#define FMPRODUCTHOTPRODUCTLISTMETHOD @"/product/productClassifyPreference/2.0.1"
#define FM_AGENT_CHOICENESS_METHOD @"/platfrom/choicenessPlatform"


#define Api_Product_ProductRedPacket @"/product/productRedPacket"

@implementation XNFinancialManagerModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 产品分类统计
- (void)fmProductCategoryStatisticWithCateIdList:(NSString *)cateIdList
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self handleProductCategoryStatisticWithArray:[self.dataDic objectForKey:@"datas"]];
                [self notifyObservers:@selector(XNFinancialManagerModuleProductCategoryStatisticListDidReceive:) withObject:self];
            }
            else {
                
                [self readLocalProductCategoryStatistic];
                [self notifyObservers:@selector(XNFinancialManagerModuleProductCategoryStatisticListDidFailed:) withObject:self];
            }
        } else {
            
            [self readLocalProductCategoryStatistic];
            [self notifyObservers:@selector(XNFinancialManagerModuleProductCategoryStatisticListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self readLocalProductCategoryStatistic];
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleProductCategoryStatisticListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self readLocalProductCategoryStatistic];
        [self notifyObservers:@selector(XNFinancialManagerModuleProductCategoryStatisticListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"cateIdList":cateIdList,@"method":FMPRODUCTCATEGORYSTATICMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FMPRODUCTCATEGORYSTATICMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark -  产品-产品分类列表
- (void)fmProductCategoryListWithCateId:(NSString *)strId orgCode:(NSString *)orgCode sort:(NSString *)sort order:(NSString *)order pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.productListMode = [XNFMProductCategoryListMode initProductCategoryListWithParams:self.dataDic];
                [self notifyObservers:@selector(XNFinancialManagerModuleConditionSelectedProductCountDidReceive:) withObject:self];
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
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNFinancialManagerModuleConditionSelectedProductCountDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"cateId":strId,@"order":order,@"orgCode":orgCode,@"sort":sort,@"pageIndex":pageIndex,@"pageSize":pageSize,@"method":FMPRODUCTCATEGORYLISTMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FMPRODUCTCATEGORYLISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}


#pragma mark - 对分类统计数据进行处理
- (void)handleProductCategoryStatisticWithArray:(NSArray *)params
{
    //将数据保存到本地
    [_LOGIC saveDataArray:params intoFileName:[NSString stringWithFormat:@"%@_productCategoryStatistic.plist",[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]];
    
    NSMutableArray * arr_ = [NSMutableArray array];
    NSMutableArray * arr_scroll = [NSMutableArray array];
    XNFMProductCategoryStatisticMode * pd = nil;
    XNFMProductCategoryStatisticMode * pd_Scroll = nil;
    for (NSDictionary * dic in params) {
        
        pd = [XNFMProductCategoryStatisticMode initProductCategoryStatisticWithParams:dic];
        pd_Scroll = [XNFMProductCategoryStatisticMode initProductCategoryStatisticWithParams:dic];
        
        if ([[pd_Scroll.cateName componentsSeparatedByString:@"产品"] count] > 0)
           pd_Scroll.cateName = [[pd_Scroll.cateName componentsSeparatedByString:@"产品"] objectAtIndex:0];
        [arr_ addObject:pd];
        [arr_scroll addObject:pd_Scroll];
    }
    self.productCategoryStatisticArray = arr_;
    self.productScrollCategoryStaticsticArray = arr_scroll;
   
}

#pragma mark - 调用分类统计数据失败后从本地拉去
- (void)readLocalProductCategoryStatistic
{
    NSArray * productCategoryStatisticArray = [_LOGIC readDataFromFileName:[NSString stringWithFormat:@"%@_productCategoryStatistic.plist",[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]];
    
    NSMutableArray * arr_ = [NSMutableArray array];
    XNFMProductCategoryStatisticMode * pd = nil;
    for (NSDictionary * dic in productCategoryStatisticArray) {
        
        pd = [XNFMProductCategoryStatisticMode initProductCategoryStatisticWithParams:dic];
        [arr_ addObject:pd];
    }
    self.productCategoryStatisticArray = arr_;
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


#pragma mark - 理财师佣金计算
- (void)fmProductDetailCaculateComissionWithParams:(NSDictionary *)params
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                NSMutableArray * productListArray = [NSMutableArray array];
                
                XNFMProfitCaculateMode * productList = nil;
                for (NSDictionary * dic in [self.dataDic objectForKey:XNFMPRODUCTTYPELISTDATA]) {
                    
                    productList = [XNFMProfitCaculateMode initProfitCaculateWithParams:dic];
                    [productListArray addObject:productList];
                }
                self.profitCaculateModeArray = productListArray;
                

                [self notifyObservers:@selector(XNFinancialManagerModuleProductDetailProfitCaculateDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNFinancialManagerModuleProductDetailProfitCaculateDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNFinancialManagerModuleProductDetailProfitCaculateDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleProductDetailProfitCaculateDidFailed:) withObject:self];
    };

    NSMutableDictionary * newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [newParams setValue:FMPRODUCTCACULATECOMISSIONMETHOD forKey:@"method"];
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:newParams];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FMPRODUCTCACULATECOMISSIONMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 机构列表
- (void)fmAgentListAtPageIndex:(NSString *)pageIndex
                      pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.agentListMode = [XNFMAgentListMode initAgentListWithObject:self.dataDic];
                [self notifyObservers:@selector(XNFinancialManagerModuleAgentListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleAgentListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleAgentListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleAgentListDidFailed:) withObject:self];
    };
    
    NSDictionary *paramsDictionary = nil;
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if ([NSObject isValidateInitString:token]) {
        
        paramsDictionary = @{@"token":token, @"pageIndex":pageIndex, @"pageSize":pageSize};
    }else
    {
        paramsDictionary = @{@"pageIndex":pageIndex, @"pageSize":pageSize};
    }

    NSDictionary *signedParameter = [_LOGIC getSignParams:paramsDictionary];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FM_AGENT_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}

#pragma mark - 机构筛选条件
- (void)fmAgentSelectCondition
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.agentSelectConditionMode = [XNFMAgentSelectConditionMode initAgentSelectConditionWithObject:self.dataDic];
                [self notifyObservers:@selector(XNFinancialManagerModuleAgentSelectConditionDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleAgentSelectConditionDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleAgentSelectConditionDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleAgentSelectConditionDidFailed:) withObject:self];
    };
    
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNFinancialManagerModuleAgentSelectConditionDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    NSDictionary *paramsDictionary = @{@"token":token};
    NSDictionary *signedParameter = [_LOGIC getSignParams:paramsDictionary];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FM_AGENT_LIST_SELECT_CONDITION_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}

#pragma mark - 平台信息和详情
- (void)fmAgentDetailWithOrgNo:(NSString *)orgNo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.agentDetailMode = [XNFMAgentDetailMode initAgentDetailWithObject:self.dataDic];
                [self notifyObservers:@selector(XNFinancialManagerModuleAgentDetailDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleAgentDetailDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleAgentDetailDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleAgentDetailDidFailed:) withObject:self];
    };
    
    NSDictionary *paramsDictionary = @{@"orgNo":orgNo};
    NSDictionary *signedParameter = [_LOGIC getSignParams:paramsDictionary];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FM_AGENT_DETAIL_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}

#pragma mark - 平台在售产品
- (void)fmAgentSaleProductListWithOrgNo:(NSString *)orgNo
                              pageIndex:(NSString *)pageIndex
                               pageSize:(NSString *)pageSize
                                  order:(NSString *)order
                                   sort:(NSString *)sort
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.agentSaleProductListMode = [XNFMProductCategoryListMode initProductCategoryListWithParams:self.dataDic];
                [self notifyObservers:@selector(XNFinancialManagerModuleAgentSaleProductListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleAgentSaleProductListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleAgentSaleProductListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleAgentSaleProductListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
       token = @"";
    }
    
    NSDictionary *paramsDictionary = @{@"token":token,@"deadlineValue":@"dLa", @"flowRate":@"fRa", @"ifRookie":@"	0", @"orgCode":orgNo, @"pageIndex":pageIndex, @"pageSize":pageSize, @"order":order, @"sort":sort};
    NSDictionary *signedParameter = [_LOGIC getSignParams:paramsDictionary];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FMCURRENTPRODUCTLISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取产品标的
- (void)fmRequestProductTagList
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                [self handleTagProductCategoryStatisticWithArray:[self.dataDic objectForKey:@"datas"]];
            }
            else
            {
                [self readLocalTagProductCategoryStatistic];
            }
        }
        else
        {
            [self readLocalTagProductCategoryStatistic];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self readLocalTagProductCategoryStatistic];
        [self convertRetWithError:error];
    };
    
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self readLocalTagProductCategoryStatistic];
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary *paramsDictionary = @{@"token":token, @"cateIdList":@"",@"method":FMPRODUCTTAGLISTMETHOD};
    NSDictionary *signedParameter = [_LOGIC getSignParams:paramsDictionary];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FMPRODUCTTAGLISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}

#pragma mark - 对分类统计数据进行处理
- (void)handleTagProductCategoryStatisticWithArray:(NSArray *)params
{
    //将数据保存到本地
    [_LOGIC saveDataArray:params intoFileName:[NSString stringWithFormat:@"%@_productTagCategoryStatistic.plist",[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]];
    
    NSMutableArray * arr_ = [NSMutableArray array];
    XNFMProductCategoryStatisticMode * pd = nil;
    for (NSDictionary * dic in params) {
        
        pd = [XNFMProductCategoryStatisticMode initProductCategoryStatisticWithParams:dic];
        [arr_ addObject:pd];
    }
    self.productTagCategoryStatisticArray = arr_;
}

#pragma mark - 调用分类统计数据失败后从本地拉去
- (void)readLocalTagProductCategoryStatistic
{
    NSArray * productCategoryStatisticArray = [_LOGIC readDataFromFileName:[NSString stringWithFormat:@"%@_productTagCategoryStatistic.plist",[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]];
    
    NSMutableArray * arr_ = [NSMutableArray array];
    XNFMProductCategoryStatisticMode * pd = nil;
    for (NSDictionary * dic in productCategoryStatisticArray) {
        
        pd = [XNFMProductCategoryStatisticMode initProductCategoryStatisticWithParams:dic];
        [arr_ addObject:pd];
    }
    self.productTagCategoryStatisticArray = arr_;
}

#pragma mark - 优选产品
- (void)fmRequestHotProductWithCateId:(NSString *)cateId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                NSArray * data = [self.dataDic objectForKey:@"datas"];
                
                if(data.count > 0)
                {
                   self.hotProductMode = [XNFMProductListItemMode initProductListItemWithObject:[[data objectAtIndex:0] objectForKey:@"productPageListResponse"]];
                }
                else
                {
                    self.hotProductMode = nil;
                }
            
                [self notifyObservers:@selector(XNFinancialManagerModuleHotProductStatisticCategoryListDidReceive:) withObject:self];
            }
            else {
                
                [self notifyObservers:@selector(XNFinancialManagerModuleHotProductStatisticCategoryListDidFailed:) withObject:self];
            }
        } else {
            
            [self notifyObservers:@selector(XNFinancialManagerModuleHotProductStatisticCategoryListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleHotProductStatisticCategoryListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNFinancialManagerModuleHotProductStatisticCategoryListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"cateIdList":cateId,@"method":FMPRODUCTHOTPRODUCTLISTMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FMPRODUCTHOTPRODUCTLISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 精选平台
- (void)fmAgentChoicenessPlatform
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                NSMutableArray * agentListArray = [NSMutableArray array];
                
                XNFMAgentListItemMode * mode = nil;
                for (NSDictionary * dic in [self.dataDic objectForKey:@"datas"] ) {
                    
                    mode = [XNFMAgentListItemMode initAgentListItemWithObject:dic];
                    [agentListArray addObject:mode];
                }
                self.choicenessPlatformArray = agentListArray;
                
                [self notifyObservers:@selector(XNFinancialManagerModuleAgentChoicenessPlatformDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNFinancialManagerModuleAgentChoicenessPlatformDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNFinancialManagerModuleAgentChoicenessPlatformDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNFinancialManagerModuleAgentChoicenessPlatformDidFailed:) withObject:self];
    };
    
    NSString *token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNFinancialManagerModuleAgentChoicenessPlatformDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary *paramsDictionary = @{@"token":token};
    NSDictionary *signedParameter = [_LOGIC getSignParams:paramsDictionary];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:FM_AGENT_CHOICENESS_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}


/***
 *  4.5.3 产品可用红包详情
 */
- (void)product_product_RedPacket:(NSString *)productId;
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.productRedPacketModel = [ProductRedPacketModel initWithProductRedPacketModelParams:self.dataDic];
                [self notifyObservers:@selector(product_Product_RedPacket_DidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(product_Product_RedPacket_DidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(product_Product_RedPacket_DidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(product_Product_RedPacket_DidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        token = @"";
    }
    
    NSDictionary *paramsDictionary = @{@"token":token,@"productId":productId};
    NSDictionary *signedParameter = [_LOGIC getSignParams:paramsDictionary];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:Api_Product_ProductRedPacket] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}







@end
