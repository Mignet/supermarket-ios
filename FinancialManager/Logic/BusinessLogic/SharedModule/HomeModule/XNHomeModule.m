//
//  XNHomeModule.m
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNHomeModule.h"
#import "NSObject+Common.h"

#import "XNClassRoomListMode.h"
#import "XNHomeBannerMode.h"
#import "XNHomeCommissionMode.h"
#import "XNCfgMsgListMode.h"
#import "XNHomeModuleObserver.h"
#import "XNHomeAchievementModel.h"

#define HOMEPAGEBANNERLISTMETHOD @"/homepage/advs"
#define HOME_PAGE_COMMISSION_METHOD @"/homepage/cfp/sysInfo/4.0.0"
#define HOME_PAGE_HOT_CFG_MSG_METHOD @"/app/newsTop/4.0.0"
#define HOME_PAGE_HOT_PRODUCTS_LIST_METHOD @"/product/selectedProducts/4.0.0"
#define HOME_PAGE_LIECAI_CALSSROOM_METHOD @"/growthHandbook/list/4.3.0"

#define HOME_PAGE_Lcs_Achievement @"/homepage/lcs/achievement/4.3.0"

@implementation XNHomeModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 获取首页banner列表
- (void)requestHomePageBannerList
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self convertHomePageListMode:self.dataDic];
                
                [_LOGIC saveDataDictionary:self.dataDic intoFileName:[NSString stringWithFormat:@"%@_homePageBanner.plist",[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]];
                
                [self notifyObservers:@selector(XNHomeModuleBannerListDidReceive:) withObject:self];
            }
            else {
                
                NSDictionary * dataDic = [_LOGIC readDicDataFromFileName:[NSString stringWithFormat:@"%@_homePageBanner.plist",[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]];
                if (dataDic)
                {
                    [self convertHomePageListMode:dataDic];
                }
                
                [self notifyObservers:@selector(XNHomeModuleBannerListDidFailed:) withObject:self];
            }
        } else {
            
            NSDictionary * dataDic = [_LOGIC readDicDataFromFileName:[NSString stringWithFormat:@"%@_homePageBanner.plist",[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]];
            if (dataDic)
            {
                [self convertHomePageListMode:dataDic];
            }
            
            [self notifyObservers:@selector(XNHomeModuleBannerListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        NSDictionary * dataDic = [_LOGIC readDicDataFromFileName:[NSString stringWithFormat:@"%@_homePageBanner.plist",[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]];
        if (dataDic)
        {
            [self convertHomePageListMode:dataDic];
        }
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNHomeModuleBannerListDidFailed:) withObject:self];
    };

    NSDictionary * params = @{@"appType":@"1",@"advPlacement":@"product_banner",@"method":HOMEPAGEBANNERLISTMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:HOMEPAGEBANNERLISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
    
    
}

#pragma mark - 首页banner列表转化处理
- (void)convertHomePageListMode:(NSDictionary *)dic
{
    NSMutableArray * array = [NSMutableArray array];
    NSMutableArray * imgUrlArray = [NSMutableArray array];
    NSMutableArray * imgLinkUrlArray = [NSMutableArray array];
    XNHomeBannerMode * mode = nil;
    for (NSDictionary * obj in [dic objectForKey:XNFMPRODUCTTYPELISTDATA]) {
        
        mode = [XNHomeBannerMode initBannerWithObject:obj];
        [array addObject:mode];
        [imgUrlArray addObject:mode.imgUrl];
        [imgLinkUrlArray addObject:mode.linkUrl];
        mode = nil;
    }
    self.bannerListArray = array;
    self.bannerImgUrlListArray = imgUrlArray;
    self.bannerLinkUrlListArray = imgLinkUrlArray;
}

#pragma mark - 获取佣金，出单
- (void)requestHomePageCommission
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.homeCommissionMode = [XNHomeCommissionMode initWithObject:self.dataDic];
                [self notifyObservers:@selector(XNHomeModuleCommissionDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNHomeModuleCommissionDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNHomeModuleCommissionDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNHomeModuleCommissionDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateObj:token]) {
        
        token = @"";
    }

    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:HOME_PAGE_COMMISSION_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark -热门资讯
- (void)requestHomePageHotCfgMsgList
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.homeHotCfgMsgListMode = [XNCfgMsgListMode initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNHomeModuleCfgMsgListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNHomeModuleCfgMsgListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNHomeModuleCfgMsgListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNHomeModuleCfgMsgListDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:HOME_PAGE_HOT_CFG_MSG_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 首页精选产品
- (void)requestHomePageHotProductsList
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.homeHotProductsListMode = [XNFMProductCategoryListMode initProductCategoryListWithParams:self.dataDic];
                [self notifyObservers:@selector(XNHomeModuleHotProductsListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNHomeModuleHotProductsListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNHomeModuleHotProductsListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNHomeModuleHotProductsListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        token = @"";
    }
    
    NSDictionary *paramsDictionary = @{@"token":token};
    NSDictionary *signedParameter = [_LOGIC getSignParams:paramsDictionary];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:HOME_PAGE_HOT_PRODUCTS_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}

//猎财课堂
- (void)requestLcClassRoomList
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.classRoomListMode = [XNClassRoomListMode initClassRoomListWithParams:self.dataDic];
                [self notifyObservers:@selector(XNHomeModuleLCClassRoomListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNHomeModuleLCClassRoomListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNHomeModuleLCClassRoomListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNHomeModuleLCClassRoomListDidFailed:) withObject:self];
    };
    
    NSDictionary *paramsDictionary = @{@"method":HOME_PAGE_LIECAI_CALSSROOM_METHOD};
    NSDictionary *signedParameter = [_LOGIC getSignParams:paramsDictionary];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:HOME_PAGE_LIECAI_CALSSROOM_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}

/***
 * 获取猎才大师平台业绩 /api/homepage/lcs/achievement/4.3.0
 **/
- (void)requestLcsAchievement
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.achievementModel = [XNHomeAchievementModel createXNHomeAchievementModel:self.dataDic];
                [self notifyObservers:@selector(RequestLcsAchievementDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(RequestLcsAchievementDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(RequestLcsAchievementDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(RequestLcsAchievementDidFailed:) withObject:self];
    };
    
    NSDictionary *paramsDictionary = @{@"method":HOME_PAGE_Lcs_Achievement};
    NSDictionary *signedParameter = [_LOGIC getSignParams:paramsDictionary];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:HOME_PAGE_Lcs_Achievement] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}





@end
