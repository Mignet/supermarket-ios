//
//  MyInfoModule.m
//  FinancialManager
//
//  Created by xnkj on 15/10/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNMyInformationModule.h" 
#import "NSObject+Common.h"
#import "XNMyInformationModuleObserver.h"

#import "XNMIHomePageInfoMode.h"
#import "XNMIMyProfitMode.h"
#import "XNMIMyProfitDetailListMode.h"
#import "XNMIMyProfitTypeMode.h"
#import "MIMySetMode.h"
#import "XNMIMyProfitDetailStatisticMode.h"

#import "RedPacketListMode.h"
#import "XNCfgMsgListMode.h"
#import "MIAccountBalanceMode.h"
#import "MIAccountBalanceCommonMode.h"
#import "MIMonthProfixMode.h"
#import "XNPlatformUserCenterOrProductMode.h"
#import "MIAccountCenterMode.h"
#import "XNInvestPlatformMode.h"
#import "MyAccountBookDetailMode.h"
#import "MyAccountBookInvestItemMode.h"
#import "MyAccountBookInvestListMode.h"
#import "ComissionCouponListMode.h"
#import "LevelCouponListMode.h"

#define XNMYINFOHOMEPAGEMETHOD @"/personcenter/personInfo"
#define XNMYINFOMYBUNDMETHOD @"/personcenter/personInfoFund"

#define XNMYINFOINVESTRECORDMETHOD @"/platfrom/investedPlatform/4.0.0"
#define XNMYINFOMYPROFITMETHOD @"/profit/cfplannerProfitTotal"
#define XNMYINFOMYPROFITTYPEMETHOD @"/profit/cfplannerProfitTypes"
#define XNMYINFOMYPROFITDETAILLISTSTATICSTCMETHOD @"/profit/cfplannerProfitItemTotal"
#define XNMYINFOMYPROFITLISTMETHOD @"/profit/cfplannerProfitItem"

#define XNMYINFOMYTEAMINFOMETHOD @"/personcenter/partner"
#define XNMYINFOMYTEAMLISTMETHOD @"/personcenter/partner/pageList"
#define XNMYINFOMYTEAMDETAILMETHOD @"/personcenter/partner/detail"
#define XNMYINFOMYTEAMDETAILISTMETHOD @"/personcenter/partner/salesRecordList/3.0"

#define XNMYINFOMYLEVELINFOMETHOD @"personcenter.task.level"

#define XNMYINFOPERSONSETTINGMETHOD @"/account/personcenter/setting"

#define XNMYINFOCOLEVELCOUPMONMETHOD @"/personcenter/partner/jobGradeVoucherPage"
#define XNMYINFOCOMISSIONCOUPMONMETHOD @"/addFeeCoupon/pageList/4.5.0"
#define XNMYINFOREDPACKETINFOMETHOD @"/redPacket/queryRedPacket/4.5.0"
#define XNMYINFOCANUSEDREDPACKETMETHOD @"/redPacket/queryAvailableRedPacket"
#define XNMYINFOREDPACKETCOUNTMETHOD @"/redPacket/queryCouponCount/4.5.0"
#define XNMYINFORDISPATCHREDPACKETMETHOD @"/redPacket/sendRedPacket"
#define XNMYINFORCFGDISPATCHREDPACKETMETHOD @"/redPacket/sendRedPacketToCfp/4.5.0"

#define XN_MY_ACCOUNT_BALANCE_METHOD @"/account/accountBalance"
#define XN_MYINFO_MONTH_PROFIT_TOTAL_LIST_METHOD @"/account/monthProfixTotalList/2.1"
#define XN_MYINFO_MONTH_PROFIT_STATISTICS_METHOD @"/account/monthProfixStatistics/3.0"
#define XN_MYINFO_MONTH_PROFIT_DETAIL_LIST_METHOD @"/account/monthProfixDetailList/2.1"

#define XN_MYINFO_IS_EXIST_IN_PLATFORM_METHOD @"/platfrom/isExistInPlatform"
#define XN_MYINFO_PLATFORM_IS_BIND_ORGACCT_METHOD @"/platfrom/isBindOrgAcct"
#define XN_MYINFO_PLATFORM_BIND_ACCOUNT_METHOD @"/platfrom/bindOrgAcct"
#define XN_MYINFO_PLATFORM_PRODUCT_METHOD @"/platfrom/getOrgProductUrl"
#define XN_MYINFO_PLATFORM_USER_CENTER_METHOD @"/platfrom/getOrgUserCenterUrl"
#define XN_MYINFO_ACCOUNT_CENTER_METHOD @"/user/personalCenter"
#define XN_MYINFO_ACCOUNT_ACCOUNTBOOK_METHOD @"/accountbook/statistics/4.5.0"
#define XN_MYINFO_ACCOUNT_ACCOUNTBOOK_LIST_METHOD @"/accountbook/investing/list/4.5.0"
#define XN_MYINFO_ACCOUNT_ACCOUNTBOOK_DETAIL_METHOD @"/accountbook/investing/detail/4.5.0"
#define XN_MYINFO_ACCOUNT_ACCOUNTBOOK_EDIT_METHOD @"/accountbook/investing/edit/4.5.0"
@implementation XNMyInformationModule


#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 获取首页数据
- (void)getMyInfoHomePageInfo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.homePageMode = [XNMIHomePageInfoMode initHomePageWithObject:self.dataDic];
                [self notifyObservers:@selector(XNMyInfoModuleGetHomePageDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleGetHomePageDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleGetHomePageDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleGetHomePageDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleGetHomePageDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":XNMYINFOHOMEPAGEMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFOHOMEPAGEMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
//    
//    [[EnvSwitchManager sharedClient] POST:[_LOGIC getMockRequestBaseUrl:XNMYINFOHOMEPAGEMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//获取我的基金-我的
- (void)getMyBundInfo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.bundAmount = [self.dataDic objectForKey:XN_MYINFO_MY_BUND];
                [self notifyObservers:@selector(XNMyInfoModuleGetMyBundDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleGetMyBundDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleGetMyBundDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleGetMyBundDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleGetMyBundDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":XNMYINFOMYBUNDMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFOMYBUNDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
//    [[EnvSwitchManager sharedClient] POST:[_LOGIC getMockRequestBaseUrl:XNMYINFOMYBUNDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取我的投资平台
- (void)getMyInvestPlatform
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.investPlatformMode = [XNInvestPlatformMode initInvestPlatformWithParams:self.dataDic];
                
                [self notifyObservers:@selector(XNMyInfoModuleGetInvestPlatformDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleGetInvestPlatformDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleGetInvestPlatformDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleGetInvestPlatformDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleGetInvestPlatformDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":XNMYINFOINVESTRECORDMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFOINVESTRECORDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
    
//    [[EnvSwitchManager sharedClient] POST:[_LOGIC getMockRequestBaseUrl:XNMYINFOINVESTRECORDMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取我的收益
- (void)getMyProfitInfoForTimeType:(NSString *)timeType time:(NSString *)timeStr
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.myProfitMode = [XNMIMyProfitMode initMyProfitWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNMyInfoModuleMyProfitDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleMyProfitDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleMyProfitDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleMyProfitDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleMyProfitDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"dateType":timeType,@"date":timeStr,@"method":XNMYINFOMYPROFITMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFOMYPROFITMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 收益明细统计
- (void)getMyProfitDetailStatisticForTimeType:(NSString *)timeType time:(NSString *)time profitType:(NSString *)profitTypeId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.myProfitDetailLisetStatisticMode = [XNMIMyProfitDetailStatisticMode initMyProfitDetailStatisticWithParams:self.dataDic];
                
                [self notifyObservers:@selector(XNMyInfoModuleMyProfitDetailListStatisticDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleMyProfitDetailListStatisticDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleMyProfitDetailListStatisticDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleMyProfitDetailListStatisticDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleMyProfitDetailListStatisticDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"dateType":timeType,@"date":time,@"profitType":profitTypeId,@"method":XNMYINFOMYPROFITDETAILLISTSTATICSTCMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFOMYPROFITDETAILLISTSTATICSTCMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
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

#pragma mark - 
- (void)requestMySettingInfo
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.settingMode = [MIMySetMode initMySetWithObject:self.dataDic];
                [self notifyObservers:@selector(XNMyInfoModulePeopleSettingDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModulePeopleSettingDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModulePeopleSettingDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModulePeopleSettingDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModulePeopleSettingDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"method":XNMYINFOPERSONSETTINGMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFOPERSONSETTINGMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//优惠券数量
- (void)requestCouponCount
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.redPacketCount = [self.dataDic objectForKey:XN_INVEST_REDPACKET_COUNT];
                self.levelCouponCount = [self.dataDic objectForKey:XN_INVEST_JOBGRADE_COUPON_COUNT];
                self.comissionCouponCount = [self.dataDic objectForKey:XN_INVEST_ADDFEECOUPON_COUNT];
                
                [self notifyObservers:@selector(XNMyInfoModuleCouponCountDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleCouponCountDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleCouponCountDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleCouponCountDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleCouponCountDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFOREDPACKETCOUNTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//可用红包列表
- (void)requestCanUsedRedPacketWithDeadLine:(NSString *)deadLine model:(NSString *)mode platform:(NSString *)platform productId:(NSString *)productId type:(NSString *)type PageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.canUsedRedPacketListMode = [RedPacketListMode initRedPacketListWithObject:self.dataDic];
                [self notifyObservers:@selector(XNMyInfoModuleCanUsedRedPacketInfoDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleCanUsedRedPacketInfoDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleCanUsedRedPacketInfoDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleCanUsedRedPacketInfoDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleCanUsedRedPacketInfoDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"deadline":deadLine,@"model":mode,@"patform":platform,@"productId":productId,@"type":type,@"pageIndex":pageIndex,@"pageSize":pageSize};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFOCANUSEDREDPACKETMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//红包列表
- (void)requestInvestRedPacketInfoWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.investRedPacketListMode = [RedPacketListMode initRedPacketListWithObject:self.dataDic];
                [self notifyObservers:@selector(XNMyInfoModuleInvestRedPacketInfoDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleInvestRedPacketInfoDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleInvestRedPacketInfoDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleInvestRedPacketInfoDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleInvestRedPacketInfoDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    NSDictionary * params = @{@"token":token,@"type":@"1",@"pageIndex":pageIndex,@"pageSize":pageSize};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFOREDPACKETINFOMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];

}

//加佣券列表
- (void)requestComissionCouponInfoWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.comissionCouponListMode = [ComissionCouponListMode initRedPacketListWithObject:self.dataDic];
                [self notifyObservers:@selector(XNMyInfoModuleCouponCountDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleCouponCountDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleCouponCountDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleCouponCountDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleCouponCountDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"pageIndex":pageIndex,@"pageSize":pageSize};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFOCOMISSIONCOUPMONMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//职级列表
- (void)requestLevelCouponInfoWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.levelCouponListMode = [LevelCouponListMode initLevelCouponListWithObject:self.dataDic];
                [self notifyObservers:@selector(XNMyInfoModuleLevelCouponDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleLevelCouponDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleLevelCouponDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleLevelCouponDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleLevelCouponDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"pageIndex":pageIndex,@"pageSize":pageSize};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFOCOLEVELCOUPMONMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 派发红包
- (void)dispatchRedPacketWithRedPacketRid:(NSString *)redPacketRid redPacketMoney:(NSString *)money usersMobile:(NSArray *)userMobilesArray
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNMyInfoModuleDispatchRedPacketDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleDispatchRedPacketDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleDispatchRedPacketDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleDispatchRedPacketDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNMyInfoModuleDispatchRedPacketDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    //将数组转化为json
    NSString * userMobileStr = @"";
    for (NSString * mobile in userMobilesArray) {
     
        userMobileStr = [userMobileStr stringByAppendingFormat:@",%@",mobile];
    }
    userMobileStr = [userMobileStr substringFromIndex:1];
    
    NSDictionary * params = @{@"token":token,@"rid":redPacketRid,@"money":money,@"userMobiles":userMobileStr};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFORDISPATCHREDPACKETMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//派发红包给理财师
- (void)dispatchRedPacketForCfgWithRedPacketRid:(NSString *)redPacketRid usersMobile:(NSArray *)userMobiles
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNMyInfoModuleCfgDispatchRedPacketInfoDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleCfgDispatchRedPacketInfoDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleCfgDispatchRedPacketInfoDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleCfgDispatchRedPacketInfoDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNMyInfoModuleCfgDispatchRedPacketInfoDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    //将数组转化为json
    NSString * userMobileStr = @"";
    for (NSString * mobile in userMobiles) {
        
        userMobileStr = [userMobileStr stringByAppendingFormat:@",%@",mobile];
    }
    userMobileStr = [userMobileStr substringFromIndex:1];
    
    NSDictionary * params = @{@"token":token,@"rid":redPacketRid,@"userMobiles":userMobileStr};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XNMYINFORCFGDISPATCHREDPACKETMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 账户余额
- (void)requestAccountBalance
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.accountBalanceMode = [MIAccountBalanceMode initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNMyInfoModuleAccountBalanceDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleAccountBalanceDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleAccountBalanceDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleAccountBalanceDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNMyInfoModuleAccountBalanceDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MY_ACCOUNT_BALANCE_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 账户余额月份收益总计列表
- (void)requestMonthProfitTotalList:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.monthProfitTotalListMode = [MIAccountBalanceCommonMode initWithAccountBalanceMonthProfixObject:self.dataDic];
                
                [self notifyObservers:@selector(XNMyInfoModuleMonthProfitTotalListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleMonthProfitTotalListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleMonthProfitTotalListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleMonthProfitTotalListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNMyInfoModuleMonthProfitTotalListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token, @"pageIndex":pageIndex, @"pageSize":pageSize};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_MONTH_PROFIT_TOTAL_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 月度收益统计
- (void)requestMonthProfitStatisticsWithMonth:(NSString *)month
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.monthProfixMode = [MIMonthProfixMode initWithObject:self.dataDic];
                
                [self notifyObservers:@selector(XNMyInfoModuleMonthProfitStatisticsDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleMonthProfitStatisticsDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleMonthProfitStatisticsDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleMonthProfitStatisticsDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNMyInfoModuleMonthProfitStatisticsDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token, @"month":month};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_MONTH_PROFIT_STATISTICS_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 月度收益明细列表
- (void)requestMonthProfitDetailListWithMonth:(NSString *)month
                                    pageIndex:(NSString *)pageIndex
                                     pageSize:(NSString *)pageSize
                                   profixType:(NSString *)profixType
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData)
        {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                switch ([profixType integerValue])
                {
                    case 1: //待发放
                    {
                        self.waiGrantMonthProfitDetailListMode = [MIAccountBalanceCommonMode initWithMonthProfixListObject:self.dataDic];
                        self.waiGrantMonthProfitDetailListMode.type = profixType;
                    }
                        break;
                    case 2: //已发放
                    {
                        self.grantMonthProfitDetailListMode = [MIAccountBalanceCommonMode initWithMonthProfixListObject:self.dataDic];
                        self.grantMonthProfitDetailListMode.type = profixType;
                    }
                        break;
                    default:
                        break;
                }
                self.monthProfitDetailListMode = [MIAccountBalanceCommonMode initWithMonthProfixListObject:self.dataDic];
                self.monthProfitDetailListMode.type = profixType;
                
                [self notifyObservers:@selector(XNMyInfoModuleMonthProfitDetailListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNMyInfoModuleMonthProfitDetailListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNMyInfoModuleMonthProfitDetailListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleMonthProfitDetailListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token])
    {
        [self notifyObservers:@selector(XNMyInfoModuleMonthProfitDetailListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token, @"month":month, @"pageIndex":pageIndex, @"pageSize":pageSize, @"profixType":profixType};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_MONTH_PROFIT_DETAIL_LIST_METHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 是否存在于第三方平台
- (void)isExistInPlatform:(NSString *)orgNo
{
    //网络请求成功
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.isExistForThirdOrg = [[self.dataDic objectForKey:@"isExist"] boolValue];
                [self notifyObservers:@selector(XNMyInfoModuleIsExistInPlatformDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyInfoModuleIsExistInPlatformDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyInfoModuleIsExistInPlatformDidFailed:) withObject:self];
        }
    };
    
    //网络请求失败
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error) {
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleIsExistInPlatformDidFailed:) withObject:self];
    };
    
    /*
     进行网络请求
     */
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (token == nil || [token isKindOfClass:[NSNull class]] || [token isEqual:[NSNull null]])
    {
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token, @"platFromNumber":orgNo};
    
    NSDictionary *signedParam = [_LOGIC getSignParams:params];
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_IS_EXIST_IN_PLATFORM_METHOD]
                           parameters:signedParam
                              success:^(id operation, id responseObject) {
                                  
                                  requestSuccessBlock(responseObject);
                                  
                              } failure:^(id operation, NSError *error) {
                                  requestFailureBlock(error);
                              }];
}

#pragma mark - 是否已绑定的机构
- (void)isBindOrgAcct:(NSString *)orgNo
{
    //网络请求成功
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.isBindCurOrg = [[self.dataDic objectForKey:@"isBind"] boolValue];
                [self notifyObservers:@selector(XNMyInfoModuleIsBindOrgAcctDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyInfoModuleIsBindOrgAcctDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyInfoModuleIsBindOrgAcctDidFailed:) withObject:self];
        }
    };
    
    //网络请求失败
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error) {
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleIsBindOrgAcctDidFailed:) withObject:self];
    };
    
    /*
     进行网络请求
     */
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (token == nil || [token isKindOfClass:[NSNull class]] || [token isEqual:[NSNull null]])
    {
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token, @"platFromNumber":orgNo};
    
    NSDictionary *signedParam = [_LOGIC getSignParams:params];
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_PLATFORM_IS_BIND_ORGACCT_METHOD]
                           parameters:signedParam
                              success:^(id operation, id responseObject) {
                                  
                                  requestSuccessBlock(responseObject);
                                  
                              } failure:^(id operation, NSError *error) {
                                  requestFailureBlock(error);
                              }];
}

#pragma mark - 绑定平台帐号
- (void)bindPlatformAccount:(NSString *)orgNo
{
    //网络请求成功
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                
                [self notifyObservers:@selector(XNMyInfoModuleBindPlatformAccountDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyInfoModuleBindPlatformAccountDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyInfoModuleBindPlatformAccountDidFailed:) withObject:self];
        }
    };
    
    //网络请求失败
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error) {
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleBindPlatformAccountDidFailed:) withObject:self];
    };
    
    /*
     进行网络请求
     */
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (token == nil || [token isKindOfClass:[NSNull class]] || [token isEqual:[NSNull null]])
    {
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token, @"platFromNumber":orgNo};
    
    NSDictionary *signedParam = [_LOGIC getSignParams:params];
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_PLATFORM_BIND_ACCOUNT_METHOD]
                           parameters:signedParam
                              success:^(id operation, id responseObject) {
                                  
                                  requestSuccessBlock(responseObject);
                                  
                              } failure:^(id operation, NSError *error) {
                                  requestFailureBlock(error);
                              }];
}

#pragma mark - 绑定完成机构-产品跳转地址
- (void)requestOrgProductUrl:(NSString *)orgNo productId:(NSString *)productId
{
    //网络请求成功
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.platformProductMode = [XNPlatformUserCenterOrProductMode initWithParams:self.dataDic];
                [self notifyObservers:@selector(XNMyInfoModulePlatformProductUrlDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyInfoModulePlatformProductUrlDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyInfoModulePlatformProductUrlDidFailed:) withObject:self];
        }
    };
    
    //网络请求失败
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error) {
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModulePlatformProductUrlDidFailed:) withObject:self];
    };
    
    /*
     进行网络请求
     */
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (token == nil || [token isKindOfClass:[NSNull class]] || [token isEqual:[NSNull null]])
    {
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token, @"orgNo":orgNo, @"productId":productId};;
    if (![NSObject isValidateInitString:productId]) {
        
        params = @{@"token":token, @"orgNo":orgNo};
    }
    
    NSDictionary *signedParam = [_LOGIC getSignParams:params];
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_PLATFORM_PRODUCT_METHOD]
                           parameters:signedParam
                              success:^(id operation, id responseObject) {
                                  
                                  requestSuccessBlock(responseObject);
                                  
                              } failure:^(id operation, NSError *error) {
                                  requestFailureBlock(error);
                              }];
}

#pragma mark - 绑定完成机构-用户中心跳转地址
- (void)requestPlatformUserCenterUrl:(NSString *)orgNo
{
    //网络请求成功
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.platformUserCenterMode = [XNPlatformUserCenterOrProductMode initWithParams:self.dataDic];
                [self notifyObservers:@selector(XNMyInfoModulePlatformUserCenterUrlDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyInfoModulePlatformUserCenterUrlDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyInfoModulePlatformUserCenterUrlDidFailed:) withObject:self];
        }
    };
    
    //网络请求失败
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error) {
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModulePlatformUserCenterUrlDidFailed:) withObject:self];
    };
    
    /*
     进行网络请求
     */
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (token == nil || [token isKindOfClass:[NSNull class]] || [token isEqual:[NSNull null]])
    {
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token, @"orgNo":orgNo};
    
    NSDictionary *signedParam = [_LOGIC getSignParams:params];
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_PLATFORM_USER_CENTER_METHOD]
                           parameters:signedParam
                              success:^(id operation, id responseObject) {
                                  
                                  requestSuccessBlock(responseObject);
                                  
                              } failure:^(id operation, NSError *error) {
                                  requestFailureBlock(error);
                              }];
}

#pragma mark - 个人中心
- (void)requestAccountCenter
{
    //网络请求成功
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.accountCenterMode = [MIAccountCenterMode initWithObject:self.dataDic];
                [self notifyObservers:@selector(XNMyInfoModuleAccountCenterDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyInfoModuleAccountCenterDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyInfoModuleAccountCenterDidFailed:) withObject:self];
        }
    };
    
    //网络请求失败
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error) {
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleAccountCenterDidFailed:) withObject:self];
    };
    
    /*
     进行网络请求
     */
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (token == nil || [token isKindOfClass:[NSNull class]] || [token isEqual:[NSNull null]])
    {
        token = @"";
    }
    
    NSDictionary * params = @{@"token":token};
    
    NSDictionary *signedParam = [_LOGIC getSignParams:params];
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_ACCOUNT_CENTER_METHOD]
                           parameters:signedParam
                              success:^(id operation, id responseObject) {
                                  
                                  requestSuccessBlock(responseObject);
                                  
                              } failure:^(id operation, NSError *error) {
                                  requestFailureBlock(error);
                              }];
}

/**
 * 记账本统计
 **/
- (void)requestAccountBookStatistics
{
    //网络请求成功
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.accountBookDetailMode = [MyAccountBookDetailMode initAccountBookDetailWithParams:self.dataDic];
                [self notifyObservers:@selector(XNMyInfoModuleAccountBookDetailDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyInfoModuleAccountBookDetailDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyInfoModuleAccountBookDetailDidFailed:) withObject:self];
        }
    };
    
    //网络请求失败
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error) {
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleAccountBookDetailDidFailed:) withObject:self];
    };
    
    /*
     进行网络请求
     */
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleAccountBookDetailDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"method":XN_MYINFO_ACCOUNT_ACCOUNTBOOK_METHOD};
    
    NSDictionary *signedParam = [_LOGIC getSignParams:params];
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_ACCOUNT_ACCOUNTBOOK_METHOD]
                               parameters:signedParam
                                  success:^(id operation, id responseObject) {
                                      
                                      requestSuccessBlock(responseObject);
                                      
                                  } failure:^(id operation, NSError *error) {
                                      requestFailureBlock(error);
                                  }];
}

/**
 * 记账本投资列表
 **/
- (void)requestAccountBookInvestListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    //网络请求成功
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.accountBookInvestListMode = [MyAccountBookInvestListMode initAccountBookInvestListWithParams:self.dataDic];
                [self notifyObservers:@selector(XNMyInfoModuleAccountBookInvestListDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyInfoModuleAccountBookInvestListDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyInfoModuleAccountBookInvestListDidFailed:) withObject:self];
        }
    };
    
    //网络请求失败
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error) {
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleAccountBookInvestListDidFailed:) withObject:self];
    };
    
    /*
     进行网络请求
     */
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleAccountBookInvestListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"pageIndex":pageIndex,@"pageSize":pageSize,@"method":XN_MYINFO_ACCOUNT_ACCOUNTBOOK_LIST_METHOD};
    
    NSDictionary *signedParam = [_LOGIC getSignParams:params];
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_ACCOUNT_ACCOUNTBOOK_LIST_METHOD]
                               parameters:signedParam
                                  success:^(id operation, id responseObject) {
                                      
                                      requestSuccessBlock(responseObject);
                                      
                                  } failure:^(id operation, NSError *error) {
                                      requestFailureBlock(error);
                                  }];
}

/**
 * 记账本详情
 * params detailId 详情id
 **/
- (void)requestAccountBookItemDetail:(NSString *)detailId
{
    //网络请求成功
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                self.accountBookInvestItemMode = [MyAccountBookInvestItemMode initAccountBookInvestItemWithParams:self.dataDic];
                [self notifyObservers:@selector(XNMyInfoModuleAccountBookInvestDetailDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyInfoModuleAccountBookInvestDetailDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyInfoModuleAccountBookInvestDetailDidFailed:) withObject:self];
        }
    };
    
    //网络请求失败
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error) {
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleAccountBookInvestDetailDidFailed:) withObject:self];
    };
    
    /*
     进行网络请求
     */
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleAccountBookInvestDetailDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"id":detailId,@"method":XN_MYINFO_ACCOUNT_ACCOUNTBOOK_DETAIL_METHOD};
    
    NSDictionary *signedParam = [_LOGIC getSignParams:params];
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_ACCOUNT_ACCOUNTBOOK_DETAIL_METHOD]
                               parameters:signedParam
                                  success:^(id operation, id responseObject) {
                                      
                                      requestSuccessBlock(responseObject);
                                      
                                  } failure:^(id operation, NSError *error) {
                                      requestFailureBlock(error);
                                  }];
}

/**
 * 记账本编辑
 **/
- (void)requestAccountBookEditWithDetailId:(NSString *)detailId investAmt:(NSString *)investAmt investDirection:(NSString *)direction profit:(NSString *)profit remark:(NSString *)remark status:(BOOL)status
{
    //网络请求成功
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            if ([self.retCode.ret isEqualToString:@"0"])
            {
                [self notifyObservers:@selector(XNMyInfoModuleAccountBookEditDidReceive:) withObject:self];
            }
            else
            {
                [self notifyObservers:@selector(XNMyInfoModuleAccountBookEditDidFailed:) withObject:self];
            }
        }
        else
        {
            [self notifyObservers:@selector(XNMyInfoModuleAccountBookEditDidFailed:) withObject:self];
        }
    };
    
    //网络请求失败
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error) {
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNMyInfoModuleAccountBookEditDidFailed:) withObject:self];
    };
    
    /*
     进行网络请求
     */
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNMyInfoModuleAccountBookEditDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"id":detailId,@"investAmt":investAmt,@"investDirection":direction,@"profit":profit,@"remark":remark,@"status":[NSNumber numberWithBool:status],@"method":XN_MYINFO_ACCOUNT_ACCOUNTBOOK_EDIT_METHOD};
    
    NSDictionary *signedParam = [_LOGIC getSignParams:params];
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:XN_MYINFO_ACCOUNT_ACCOUNTBOOK_EDIT_METHOD]
                               parameters:signedParam
                                  success:^(id operation, id responseObject) {
                                      
                                      requestSuccessBlock(responseObject);
                                      
                                  } failure:^(id operation, NSError *error) {
                                      requestFailureBlock(error);
                                  }];
}
@end
