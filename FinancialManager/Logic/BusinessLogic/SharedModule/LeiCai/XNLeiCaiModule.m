//
//  XNLeiCaiModule.m
//  FinancialManager
//
//  Created by xnkj on 04/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNLeiCaiModule.h"

#import "NSObject+Common.h"

#import "LieCaiMode.h"
#import "XNHomeBannerMode.h"
#import "XNCfgMsgListMode.h"
#import "XNLCSchoolListMode.h"
#import "XNLCActivityListMode.h"
#import "XNLCAgentActivityListModel.h"
#import "XNLeiCaiModuleObserver.h"
#import "XNLCBrandPromotionMode.h"
#import "XNLCPersonalCardMode.h"
#import "XNLCLevelPrivilegeMode.h"
#import "XNLCSaleGoodNewsListMode.h"
#import "XNLCSaleGoodNewsItemMode.h"
#import "XNGrowthManualListMode.h"


/******* 4.5.0 (新增) *****/
#import "SeekTreasureHotActivityModel.h"
#import "SeekTreasureHotActivityItemModel.h"
#import "SeekTreasureReadListModel.h"
#import "SeekTreasureRecommendListModel.h"
#import "SeekActivityListModel.h"

/***** 4.5.3 (新增) ******/
#import "XNLCBrandPostersmModel.h"

#define XN_MYINFO_CFG_MSG_METHOD @"/app/newsPageList"
#define XNLEICAIACTIVITYLISTMETHOD  @"/activity/platform"
#define XNLEICAIACTIVITYPLATFORMLISTMETHOD @"/activity/platform/pageList"
#define XNLEICAISCHOOLLISTMETHOD @"/classroom/queryClassroomList"
#define XNLEICAIUNREADINFORMATIONMETHOD @"/app/newsandactivity/readed/2.0.2"

#define HOMEPAGEBANNERLISTMETHOD @"/homepage/advs"

#define XN_LIECAI_HOME_PAGE_METHOD @"/app/newsandactivity/readed/2.0.2"
#define XN_LIECAI_HOME_ACTIVITY_METHOD @"/activity/platform/list"
#define XN_LIECAI_HOME_BRAND_PROMOTION_METHOD @"/user/brandPromotion"
#define XN_LIECAI_HOME_PERSONAL_CARD_METHOD @"/user/userInfo"
#define XN_LIECAI_HOME_LEVEL_PRIVILEGE_METHOD @"/personcenter/directCfpJobGrade"
#define XN_LIECAI_HOME_SALE_GOOD_NEWS_DETAIL_METHOD @"/personcenter/goodTrans"
#define XN_LIECAI_HOME_SALE_GOOD_NEWS_LIST_METHOD @"/personcenter/queryOldGoodTrans"
#define XN_LIECAI_HOME_GROWTH_MANUAL_CATEGORY_METHOD @"/growthHandbook/classify/4.1.1"
#define XN_LIECAI_HOME_PERSONAL_CUSTOM_LIST_METHOD @"/growthHandbook/personalCustomization/4.1.1"
#define XN_LIECAI_HOME_GROWTH_MANUAL_CATEGORY_LIST_METHOD @"/growthHandbook/classifyList/4.1.1"
#define XN_LIECAI_HOME_HAVE_GOOD_TRANS_NO_READ_METHOD @"/personcenter/haveGoodTransNoRead"


/****** 4.5.0 (新增接口) *******/
#define SEEK_TREASURE_HOT_ACTIVITY_LIST @"/activity/platform/list"
#define SEEK_TREASURE_HOT_RECOMMEND_LIST @"/classroom/selectedRecomend/list/4.5.0"
#define SEEK_TREASURE_HOT_READ_LIST @"/growthHandbook/personalCustomization/4.1.1"
#define SEEK_TREASURE_HOT_ACITIVITY_LIST @"/activity/pageList"


/***** 4.5.3 (新增接口) ***/
// 推广海报
#define XN_LIECAI_User_BrandPosters @"/user/brandPosters"
// 推广海报类型
#define XN_LIECAI_User_PostersType @"/user/postersType"



@implementation XNLeiCaiModule

+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

/**
 * 获首页banner
 **/
- (void)requestHomePageBannerList
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self convertHomePageListMode:self.dataDic];
                
                [_LOGIC saveDataDictionary:self.dataDic intoFileName:[NSString stringWithFormat:@"%@_lcBanner.plist",[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]];
                
                
                [self notifyObservers:@selector(XNHomeModuleLcBannerListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNHomeModuleLcBannerListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNHomeModuleLcBannerListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNHomeModuleLcBannerListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNHomeModuleLcBannerListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"appType":@"1",@"advPlacement":@"liecai_banner",@"method":HOMEPAGEBANNERLISTMETHOD};
    
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

#pragma mark - 个人品牌推广(type：1邀请理财师 2邀请客户)
- (void)requestBrandPromotion:(NSString *)type
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.cfpBrandPromotionMode = nil;
                self.customerBrandPromotionMode = nil;
                if ([type integerValue] == 1)
                {
                    //推荐理财师
                    self.cfpBrandPromotionMode = [XNLCBrandPromotionMode initWithObject:self.dataDic];
                }
                else
                {
                    //邀请客户
                    self.customerBrandPromotionMode = [XNLCBrandPromotionMode initWithObject:self.dataDic];
                }
                
                
                [self notifyObservers:@selector(XNLeiCaiModuleBrandPromotionDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNLeiCaiModuleBrandPromotionDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNLeiCaiModuleBrandPromotionDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNLeiCaiModuleBrandPromotionDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNLeiCaiModuleBrandPromotionDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token ,@"type":type};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_LIECAI_HOME_BRAND_PROMOTION_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 个人名片
- (void)requestPersonalCard:(NSString *)type
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.personalCardMode = [XNLCPersonalCardMode initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNLeiCaiModulePersonalCardDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNLeiCaiModulePersonalCardDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNLeiCaiModulePersonalCardDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNLeiCaiModulePersonalCardDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNLeiCaiModulePersonalCardDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token ,@"type":type};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_LIECAI_HOME_PERSONAL_CARD_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 职级特权
- (void)requestLevelPrivilegeWithUserId:(NSString *)userId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.levelPrivilegeMode = [XNLCLevelPrivilegeMode initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNLeiCaiModuleLevelPrivilegeDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNLeiCaiModuleLevelPrivilegeDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNLeiCaiModuleLevelPrivilegeDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNLeiCaiModuleLevelPrivilegeDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNLeiCaiModuleLevelPrivilegeDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"userId":userId};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_LIECAI_HOME_LEVEL_PRIVILEGE_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 出单喜报
- (void)requestSaleGoodNewsDetailWithId:(NSString *)billId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.saleGoodNewsItemMode = [XNLCSaleGoodNewsItemMode initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNLeiCaiModuleSaleGoodNewsDetailDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNLeiCaiModuleSaleGoodNewsDetailDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNLeiCaiModuleSaleGoodNewsDetailDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNLeiCaiModuleSaleGoodNewsDetailDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNLeiCaiModuleSaleGoodNewsDetailDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token, @"billId":billId};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[JHttpsClient sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_LIECAI_HOME_SALE_GOOD_NEWS_DETAIL_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 往期喜报
- (void)requestSaleGoodNewsListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize sort:(NSString *)sort
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.saleGoodNewsListMode = [XNLCSaleGoodNewsListMode initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNLeiCaiModuleSaleGoodNewsListDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNLeiCaiModuleSaleGoodNewsListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNLeiCaiModuleSaleGoodNewsListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNLeiCaiModuleSaleGoodNewsListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNLeiCaiModuleSaleGoodNewsListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token, @"pageIndex":pageIndex, @"pageSize":pageSize, @"sort":sort};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[JHttpsClient sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_LIECAI_HOME_SALE_GOOD_NEWS_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 成长手册分类
- (void)requestGrowthManualCategory
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.growthManualCategoryMode = [XNGrowthManualListMode initWithCategoryObject:self.dataDic];
                
                [self notifyObservers:@selector(XNLeiCaiModuleGrowthManualCategoryDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNLeiCaiModuleGrowthManualCategoryDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNLeiCaiModuleGrowthManualCategoryDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNLeiCaiModuleGrowthManualCategoryDidFailed:) withObject:self];
    };
    
    NSDictionary * params = [NSDictionary dictionary];
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[JHttpsClient sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_LIECAI_HOME_GROWTH_MANUAL_CATEGORY_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 个人定制列表
- (void)requestPersonalCustomList
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.personalCustomListMode = [XNGrowthManualListMode initWithPersonalCustomListObject:self.dataDic];
                
                [self notifyObservers:@selector(XNLeiCaiModulePersonalCustomListDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNLeiCaiModulePersonalCustomListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNLeiCaiModulePersonalCustomListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNLeiCaiModulePersonalCustomListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[JHttpsClient sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_LIECAI_HOME_PERSONAL_CUSTOM_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 分类列表
- (void)requestGrowthManualCategoryListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize typeCode:(NSString *)typeCode
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.growthManualCategoryListMode = [XNGrowthManualListMode initWithCategoryListObject:self.dataDic];
                
                [self notifyObservers:@selector(XNLeiCaiModuleGrowthManualCategoryListDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNLeiCaiModuleGrowthManualCategoryListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNLeiCaiModuleGrowthManualCategoryListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNLeiCaiModuleGrowthManualCategoryListDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{@"pageIndex":pageIndex, @"pageSize":pageSize, @"typeCode":typeCode};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[JHttpsClient sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_LIECAI_HOME_GROWTH_MANUAL_CATEGORY_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 未读喜报
- (void)requestUnReadSaleGoodNews
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                //0无1有
                self.isHaveNewSaleGoodNews = [[self.dataDic objectForKey:@"haveRead"] boolValue];
                
                [self notifyObservers:@selector(XNLeiCaiModuleUnReadSaleGoodNewsDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNLeiCaiModuleUnReadSaleGoodNewsDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNLeiCaiModuleUnReadSaleGoodNewsDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNLeiCaiModuleUnReadSaleGoodNewsDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNLeiCaiModuleUnReadSaleGoodNewsDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[JHttpsClient sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_LIECAI_HOME_HAVE_GOOD_TRANS_NO_READ_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}


/***
 * 热门活动 (4.5.0) (获取猎才热门活动)
 **/
- (void)requestSeekTreasureHotActivity
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.SeekTreasureHotActivityModel = [SeekTreasureHotActivityModel initSeekTreasureHotActivityModelWithParams:self.dataDic];
                
                [self notifyObservers:@selector(SeekRequestSeekTreasureHotActivityDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(SeekRequestSeekTreasureHotActivityDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(SeekRequestSeekTreasureHotActivityDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(SeekRequestSeekTreasureHotActivityDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[JHttpsClient sharedClient] POST:[_LOGIC getShaRequestBaseUrl:SEEK_TREASURE_HOT_ACTIVITY_LIST] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];

}


/***
 * 猎才-精选推荐
 **/
- (void)requestSeekTreasureRecommend
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.seekTreasureRecommendListModel = [SeekTreasureRecommendListModel initSeekTreasureRecommendListModelWithParams:self.dataDic];
                
                [self notifyObservers:@selector(SeekTreasureRecommendListDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(SeekTreasureRecommendListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(SeekTreasureRecommendListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(SeekTreasureRecommendListDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[JHttpsClient sharedClient] POST:[_LOGIC getShaRequestBaseUrl:SEEK_TREASURE_HOT_RECOMMEND_LIST] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];

}


/***
 * 猎才-最近热读
 **/
- (void)requestSeekTreasureRead
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                //0无1有
                self.seekTreasureReadListModel = [SeekTreasureReadListModel initSeekTreasureReadListModelWithParams:self.dataDic];
                
                [self notifyObservers:@selector(SeekTreasureReadListDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(SeekTreasureReadListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(SeekTreasureReadListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(SeekTreasureReadListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
       token = @"";
    }

    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[JHttpsClient sharedClient] POST:[_LOGIC getShaRequestBaseUrl:SEEK_TREASURE_HOT_READ_LIST] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

/***
 * 猎才 - 活动专区（活动列表）
 **/
- (void)requestSeekTreasureActivityListPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize AppType:(NSString *)appType
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.seekActivityListModel = [SeekActivityListModel initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(SeekActivityListModelDidSuccess:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(SeekActivityListModelDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(SeekActivityListModelDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(SeekActivityListModelDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{
                              @"pageIndex":pageIndex,
                              @"pageSize":pageSize
                              };
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[JHttpsClient sharedClient] POST:[_LOGIC getShaRequestBaseUrl:SEEK_TREASURE_HOT_ACITIVITY_LIST] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
    
}


/***
 * 推广海报类型 /user/postersType
 */

- (void)request_Liecai_User_BrandPosters
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                //保存到文件中
                [_LOGIC saveDataArray:[self.dataDic objectForKey:@"typeList"] intoFileName:@"Liecai_User_PostersType.plist"];
                
                [self notifyObservers:@selector(insurance_Liecai_User_PostersTypeDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(insurance_Liecai_User_PostersTypeDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(insurance_Liecai_User_PostersTypeDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        [self convertRetWithError:error];
        [self notifyObservers:@selector(insurance_Liecai_User_PostersTypeDidFailed:) withObject:self];
    };
    
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(insurance_Liecai_User_PostersTypeDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"method":XN_LIECAI_User_PostersType, @"token":token};
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_LIECAI_User_PostersType] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
    
    
}

/***
 * 推广海报 user/postersType
 */
- (void)request_Liecai_User_PostersType:(NSString *)type
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.brandPostersmModel = [XNLCBrandPostersmModel createBrandPostersmModel:self.dataDic];
                
                [self notifyObservers:@selector(insurance_Liecai_User_BrandPostersDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(insurance_Liecai_User_BrandPostersDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(insurance_Liecai_User_BrandPostersDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        [self convertRetWithError:error];
        [self notifyObservers:@selector(insurance_Liecai_User_BrandPostersDidFailed:) withObject:self];
    };
    
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(insurance_Liecai_User_BrandPostersDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"method":XN_LIECAI_User_BrandPosters, @"token":token, @"type":type};
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_LIECAI_User_BrandPosters] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
    
}


@end
