//
//  XNMessageModule.m
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNCommonModule.h"
#import "NSObject+Common.h"
#import "XNCommonModuleObserver.h"

#import "XNUpgradeMode.h"
#import "XNConfigMode.h"
#import "XNHomeBannerMode.h"
#import "XNRemindPopMode.h"
#import "XNNewComissionCouponMode.h"
#import "XNComissionNewRecordMode.h"
#import "XNNewLevelCouponMode.h"

#define XNCOMMONMESSAGELISTMETHOD @"/app/appVersion"
#define XNCOMMONMCONFIGMETHOD @"/app/default-config"
#define XNCOMMONGETBUGMETHOD @"/app/iosPatchData"
#define XN_COMMON_BANNER_METHOD @"/homepage/advs"
#define XN_HOME_POP_ADV_METHOD @"/homepage/product/opening/2.1.0"
#define XN_HOME_REMIND_POP_METHOD @"/cim/crmcfplevelrecordtemp/cfpLevelWarning"
#define XN_HOME_NEW_USER_METHOD @"/user/isNew"
#define XN_HOME_NEWADDFEECOUPON_METHOD @"/homepage/hasNewAddFeeCoupon/4.5.0"
#define XN_HOME_NEWNEWREDPACKET_METHOD @"/homepage/hasNewRedPacket/4.5.0"
#define XN_HOME_HASNEWADDFEE_METHOD @"/homepage/hasNewAddFee/4.5.0"
#define XN_HOME_LEVELCOUPON_METHOD @"/personcenter/partner/jobGradeVoucherPopup"

#define App_sysConfig_config @"/app/sysConfig/config"


@implementation XNCommonModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 查看app是否升级
- (void)checkAppUpgrade
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.upgradeMode = [XNUpgradeMode initUpgradeWithObject:self.dataDic];
                [self notifyObservers:@selector(XNCommonModuleUpgradeDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCommonModuleUpgradeDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCommonModuleUpgradeDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCommonModuleUpgradeDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{@"method":XNCOMMONMESSAGELISTMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNCOMMONMESSAGELISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取配置信息
- (void)requestConfigInfo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
       
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.configMode = [XNConfigMode initConfigWithObject:self.dataDic];
                [self notifyObservers:@selector(XNCommonModuleConfigDidReceive:) withObject:self];
            }
            else {
                
                self.configMode = [XNConfigMode initConfigWithObject:[_LOGIC readDicDataFromFileName:@"config.plist"]];
                [self notifyObservers:@selector(XNCommonModuleConfigDidFailed:) withObject:self];
            }
        } else {
            
            self.configMode = [XNConfigMode initConfigWithObject:[_LOGIC readDicDataFromFileName:@"config.plist"]];
            [self notifyObservers:@selector(XNCommonModuleConfigDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        self.configMode = [XNConfigMode initConfigWithObject:[_LOGIC readDicDataFromFileName:@"config.plist"]];
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCommonModuleConfigDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNCOMMONMCONFIGMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取bug补丁
- (void)userGetPatch
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
            
                [self saveBugCodeToJsonFile:self.dataDic];
                
                [self notifyObservers:@selector(XNUserModuleGetBugCodeDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNUserModuleGetBugCodeDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNUserModuleGetBugCodeDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNUserModuleGetBugCodeDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{@"method":XNCOMMONGETBUGMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNCOMMONGETBUGMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 将bug代码写入本地json文件中
- (void)saveBugCodeToJsonFile:(NSDictionary *)dic
{
    NSString * bugCodeStr = [dic objectForKey:@"pathchData"];
    
    if ([NSObject isValidateInitString:bugCodeStr]) {

        [_LOGIC saveString:[NSString encryptUseDES:bugCodeStr] intoFileName:@"bugFix.js"];
    }
}

#pragma mark - 广告查询
- (void)requestBannerWithAdvPlacement:(NSString *)advPlacement
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                NSDictionary *dic = [[self.dataDic objectForKey:@"datas"] firstObject];
                
                //日进斗金
                if ([advPlacement isEqualToString:@"product_day"])
                {
                    self.shortTermProductImageUrl = [dic objectForKey:@"imgUrl"];
                }
                else if ([advPlacement isEqualToString:@"product_year"])
                {
                    //年年有余
                    self.longTermProductImageUrl = [dic objectForKey:@"imgUrl"];
                }
                else
                {
                    [self convertBannerMode:self.dataDic advPlacement:advPlacement];
                }
                
                [self notifyObservers:@selector(XNCommonModuleBannerDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCommonModuleBannerDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCommonModuleBannerDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCommonModuleBannerDidFailed:) withObject:self];
    };
    
    //appType 端口 (理财师1，投资端2)
    NSDictionary * params = @{@"advPlacement":advPlacement, @"appType":@"1"};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_COMMON_BANNER_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - banner列表转化处理
- (void)convertBannerMode:(NSDictionary *)dic advPlacement:(NSString *)advPlacement
{
    NSMutableArray * array = [NSMutableArray array];
    NSMutableArray * imgUrlArray = [NSMutableArray array];
    NSMutableArray * imgLinkUrlArray = [NSMutableArray array];
    XNHomeBannerMode * mode = nil;
    for (NSDictionary * obj in [dic objectForKey:@"datas"]) {
        
        mode = [XNHomeBannerMode initBannerWithObject:obj];
        [array addObject:mode];
        [imgUrlArray addObject:mode.imgUrl];
        [imgLinkUrlArray addObject:mode.linkUrl];
        mode = nil;
    }
    
    //平台banner
    if ([advPlacement isEqual:@"platform_banner"])
    {
        [_LOGIC saveDataDictionary:dic intoFileName:[NSString stringWithFormat:@"%@_platformBanner.plist",[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]];
        self.platformBannerListArray = array;
        self.platformBannerImgUrlListArray = imgUrlArray;
        self.platformBannerLinkUrlListArray = imgLinkUrlArray;
    }
    else if ([advPlacement isEqual:@"product_banner"])
    {
        //产品banner
        [_LOGIC saveDataDictionary:dic intoFileName:[NSString stringWithFormat:@"%@_productBanner.plist",[_LOGIC getValueForKey:XN_USER_MOBILE_TAG]]];
        self.productBannerListArray = array;
        self.productBannerImgUrlListArray = imgUrlArray;
        self.productBannerLinkUrlListArray = imgLinkUrlArray;
    }
    
}

#pragma mark - 首页产品弹出窗
- (void)requestHomeWithPopAdv
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.homePopAdvMode = [XNHomeBannerMode initBannerWithObject:self.dataDic];
                [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_POP_ADV_TAG Value:@"0"];
                //获取旧数据
                NSDictionary *oldDictionary = [_LOGIC readDicDataFromFileName:@"homePopAdv.plist"];
                
                if (self.homePopAdvMode != nil)
                {
                    [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_POP_ADV_TAG Value:@"1"];
                    XNHomeBannerMode *oldHomePopAdvMode = [XNHomeBannerMode initBannerWithObject:oldDictionary];
                    
                    //如果新数据和旧数据不一致，则弹出窗
                    if ([oldHomePopAdvMode.imgUrl isEqualToString:self.homePopAdvMode.imgUrl])
                    {
                        [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_POP_ADV_TAG Value:@"0"];
                    }
                }
                //保存数据
                [_LOGIC saveDataDictionary:self.dataDic intoFileName:@"homePopAdv.plist"];
                
                [self notifyObservers:@selector(XNCommonModuleHomePopAdvDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCommonModuleHomePopAdvDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCommonModuleHomePopAdvDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCommonModuleHomePopAdvDidFailed:) withObject:self];
    };
    
    
    //appType 端口 (理财师1，投资端2)
    NSDictionary * params = @{@"appType":@"1"};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];

    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_HOME_POP_ADV_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//请求首页提示信息
- (void)requestHomeRemindInfo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.remindPopMode = [XNRemindPopMode initRemindPopWithParams:self.dataDic];
                
                [self notifyObservers:@selector(XNCommonModuleRemindPopDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCommonModuleRemindPopDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCommonModuleRemindPopDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCommonModuleRemindPopDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateObj:token]) {
        
        token = @"";
    }
    
    //appType 端口 (理财师1，投资端2)
    NSDictionary * params = @{@"token":token, @"appType":@"1"};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_HOME_REMIND_POP_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//首页-是否有新的加佣券
- (void)requestHomeNewComissionCoupon
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                
                if ([[self.dataDic objectForKey:XN_NEW_COMISSIONCOUPON_HASNEWADDFEECOUPON] boolValue]) {
                    
                    self.hasNewcomissionCouponMode = [XNNewComissionCouponMode initComissionCouponWithParams:self.dataDic];
                    
                    [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_TAG Value:@"1"];
                    
                    [self notifyObservers:@selector(XNCommonModuleNewComissionCouponDidReceive:) withObject:self];
                }else if([NSObject isValidateInitString:[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_TAG]] && [[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_TAG] integerValue] == 1 && !self.hasNewcomissionCouponMode)
                {
                    NSDictionary * params = [_LOGIC getNSDictionaryForKey:XN_HOME_COMISSION_COUPON_DICTIONARY];
                    self.hasNewcomissionCouponMode =  [XNNewComissionCouponMode initComissionCouponWithParams:params];
                }else if(!([NSObject isValidateInitString:[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_TAG]] && [[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_TAG] integerValue] == 1))
                {
                    [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_TAG Value:@"0"];
                }
            }
            else {
                [self notifyObservers:@selector(XNCommonModuleNewComissionCouponDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCommonModuleNewComissionCouponDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCommonModuleNewComissionCouponDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateObj:token]) {
        
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_HOME_NEWADDFEECOUPON_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//首页-是否有新的红包
- (void)requestHomeNewRedPacket
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.hasNewRedPacket = [[self.dataDic objectForKey:XN_HOME_HAS_NEWREDPACKET] boolValue];
                if (self.hasNewRedPacket) {
                    
                    [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_REDPACKET_TAG Value:@"1"];
                    
                    [self notifyObservers:@selector(XNCommonModuleNewRedPacketDidReceive:) withObject:self];
                }else if(!([NSObject isValidateInitString:[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_REDPACKET_TAG]] && [[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_REDPACKET_TAG] integerValue] == 1))
                {
                    [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_REDPACKET_TAG Value:@"0"];
                }
            }
            else {
                [self notifyObservers:@selector(XNCommonModuleNewRedPacketDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCommonModuleNewRedPacketDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCommonModuleNewRedPacketDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateObj:token]) {
        
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_HOME_NEWNEWREDPACKET_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//佣金券是否有新的使用记录
- (void)requestHomeComissionHasNewRecord
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                if ([[self.dataDic objectForKey:XN_HOME_COMISSION_NEW_RECORD_HASNEWADDFEE] boolValue]) {
                    
                    self.hasNewComissionCouponRecordMode = [XNComissionNewRecordMode initComissionNewRecordWithParams:self.dataDic];
                    
                    [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_RECORD_TAG Value:@"1"];
                    
                    [self notifyObservers:@selector(XNCommonModuleNewCouponRecordDidReceive:) withObject:self];
                }else if([NSObject isValidateInitString:[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_RECORD_TAG]] && [[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_RECORD_TAG] integerValue] == 1 && !self.hasNewComissionCouponRecordMode)
                {
                    NSDictionary * params = [_LOGIC getNSDictionaryForKey:XN_HOME_COMISSION_NEW_RECORD_DICTIONARY];
                    self.hasNewComissionCouponRecordMode =  [XNComissionNewRecordMode initComissionNewRecordWithParams:params];
                }else if(!([NSObject isValidateInitString:[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_RECORD_TAG]] && [[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_RECORD_TAG] integerValue] == 1))
                {
                    [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_COMISSIONCOUPON_RECORD_TAG Value:@"0"];
                }
            }
            else {
                [self notifyObservers:@selector(XNCommonModuleNewCouponRecordDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCommonModuleNewCouponRecordDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCommonModuleNewCouponRecordDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateObj:token]) {
        
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_HOME_HASNEWADDFEE_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//是否有新的职级体验券
- (void)requestNewLeveCoupon
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                if ([[self.dataDic objectForKey:XN_NEW_LEVELCOUPON_HASNEWADDFEECOUPON] boolValue]) {
                    
                    self.levelCouponMode = [XNNewLevelCouponMode initLevelCouponWithParams:self.dataDic];
                    [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_LEVELCOUPON_TAG Value:@"1"];
                    
                    [self notifyObservers:@selector(XNCommonModuleNewLevelCouponRecordDidReceive:) withObject:self];
                }else if([NSObject isValidateInitString:[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_LEVELCOUPON_TAG]] && [[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_LEVELCOUPON_TAG] integerValue] == 1 && !self.levelCouponMode)
                {
                    NSDictionary * params = [_LOGIC getNSDictionaryForKey:XN_NEW_LEVELCOUPON_DICTIONARY];
                    self.levelCouponMode =  [XNNewLevelCouponMode initLevelCouponWithParams:params];
                }else if(!([NSObject isValidateInitString:[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_LEVELCOUPON_TAG]] && [[_LOGIC getValueForKey:XN_IS_SHOW_HOME_NEW_LEVELCOUPON_TAG] integerValue] == 1))
                {
                    [_LOGIC saveValueForKey:XN_IS_SHOW_HOME_NEW_LEVELCOUPON_TAG Value:@"0"];
                }
            }
            else {
                [self notifyObservers:@selector(XNCommonModuleNewLevelCouponRecordDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCommonModuleNewLevelCouponRecordDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCommonModuleNewLevelCouponRecordDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateObj:token]) {
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_HOME_LEVELCOUPON_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

/***
 * 系统所有参数配置
 */
- (void)request_App_SysConfig_ConfigKey:(NSString *)configKey configType:(NSString *)configType
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            
            self.retCode = [self convertRetJsonData:jsonData];
            if ([self.retCode.ret isEqualToString:@"0"]) { // 请求成功
                [_LOGIC saveValueForKey:App_sysConfig_config_configValue Value:self.dataDic[@"configValue"]];
            }
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        [self convertRetWithError:error];
        //[self notifyObservers:@selector(XNCommonModuleNewRedPacketDidFailed:) withObject:self];
    };
    
    NSDictionary * params = @{@"appType":@"1", @"configKey":configKey, @"configType":configType};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:App_sysConfig_config] parameters:signedParameter success:^(id operation, id responseObject) {
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        requestFailureBlock(error);
    }];
}


@end
