//
//  XCustomerServerModule.m
//  FinancialManager
//
//  Created by xnkj on 15/10/16.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNCustomerServerModule.h"
#import "NSObject+Common.h"
#import "XNCustomerServerModuleObserver.h"

#import "XNCSHomePageMode.h"

#import "XNCSCfgDetailMode.h"
#import "XNCSMyCustomerInvestRecordListMode.h"
#import "XNCSMyCustomerListMode.h"
#import "XNCSCustomerDetailMode.h"
#import "XNCSMyCustomerTradeListMode.h"
#import "XNIMUserInfoMode.h"
#import "XNCSCustomerCfpMemberMode.h"
#import "XNCSNewCustomerModel.h"

#import "ReturnMoneyListModel.h"

#define CSMYCUSTOMERSSTATISTICSMETHOD @"customer.mycustomers.statistics"
#define CSHOMEPAGEDATAMETHOD   @"/customer/homepage"

#define CSINVESTSTATISTICPAGELISTMETHOD @"/investRecord/cfplanner/customerInvestRecords"


#define CSTARDELISTMETHOD      @"/investRecord/cfplanner/customerTradeMsg"

#define CSCUSTOMERLISTEMETHOD  @"/customer/mycustomers/pageList"
#define CSCUSTOMERCFGMEMBERMETHOD @"/personcenter/customerCfpmember"
#define CSNEWCUSTOMERLISTMETHOD @"/personcenter/customerCfpmemberPage"

#define CSCUSTOMERADDIMPROTANTCUSTOMERMETHOD @"/customer/important/add"
#define CSCUSTOMERREMOVEIMPROTCUSTOMERMETHOD @"/customer/important/remove"
#define CSCUSTOMERADDIMPROTANTCFGMETHOD @"/crm/cfpcommon/important/add"
#define CSCUSTOMERREMOVEIMPROTCFGMETHOD @"/crm/cfpcommon/important/remove"

#define CSCUSTOMERTRADELISTMETHOD @"/investRecord/cfplanner/customerAllTradeMsg"
#define CSACTIVITYLISTMETHOD   @"activity.pageList"
#define CSIMEASEMOBMETHOD @"/user/getUserInfoByEasemob"
#define EXPIREREDEEMMETHOD @"/personcenter/repamentCalendar"

#define CS_DECLARATION_LIST_METHOD @"/investRecord/cfplanner/unRecordInvestList"
#define CS_SELECT_AGENT_METHOD @"/platfrom/selectPlatfrom"
#define CS_COMMIT_DECLARATION_METHOD @"/investRecord/cfplanner/addUnRecordInvest"

#define CS_CFG_SALE_STATISTICS_METHOD @"/personcenter/partner/monthSaleStatistics/3.0"
#define CS_CFG_SALE_LIST_METHOD @"/personcenter/partner/monthSaleList/3.0"

#define CSCUSTOMERDETAILMETHOD @"/personcenter/customerDetail"
#define CSCUSTOMERINVESTRECORDLISTMETHOD @"/personcenter/customerInvestRecord"
#define CSIMEASEMOBMETHOD @"/user/getUserInfoByEasemob"

#define CSCFGDETAILMETHOD @"/personcenter/cfplannerDetail"

@implementation XNCustomerServerModule

#pragma mark - 初始化
+ (instancetype)defaultModule
{
    return [self globalClassObject];
}

#pragma mark - 获取首页数据
- (void)getCSHomePageData
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.homePageMode = [XNCSHomePageMode initCSHomePageWithObject:self.dataDic];
                
//                [_LOGIC saveDataDictionary:self.dataDic intoFileName:@"customerServer.plist"];
                
                [self notifyObservers:@selector(XNCustomerServerModuleGetHomePageDataDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCustomerServermoduleGetHomePageDataDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCustomerServermoduleGetHomePageDataDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCustomerServermoduleGetHomePageDataDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNCustomerServermoduleGetHomePageDataDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    
    NSDictionary * params = @{@"token":token,@"method":CSHOMEPAGEDATAMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:CSHOMEPAGEDATAMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//获取客户成员／理财师团队成员数据
- (void)getCsCustomerCfpMemberWithType:(NSString *)type
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.customerCfpMemberMode = [XNCSCustomerCfpMemberMode initCustomerCfgMemberWithParams:self.dataDic];
                
                [self notifyObservers:@selector(XNCustomerServerModuleCustomerCfpMemberDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCustomerServerModuleCustomerCfpMemberDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCustomerServerModuleCustomerCfpMemberDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCustomerServerModuleCustomerCfpMemberDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNCustomerServerModuleCustomerCfpMemberDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params=@{@"token":token,@"type":type,@"method":CSCUSTOMERCFGMEMBERMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:CSCUSTOMERCFGMEMBERMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取客户列表
- (void)getCustomerListForCustomerName:(NSString *)name customerType:(NSString *)customerType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize sort:(NSString *)sort order:(NSString *)order
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                @autoreleasepool {
                    
                    self.myCustomerListMode = [XNCSMyCustomerListMode initMyCustomerListWithObject:self.dataDic];
                }
                [self notifyObservers:@selector(XNCustomerServerModuleCustomerListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCustomerServerModuleCustomerListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCustomerServerModuleCustomerListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCustomerServerModuleCustomerListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
         [self notifyObservers:@selector(XNCustomerServerModuleCustomerListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
   
    NSDictionary * params=@{@"token":token,@"name":name,@"customerType":customerType,@"pageIndex":pageIndex,@"pageSize":pageSize,@"sort":sort,@"order":order,@"method":CSCUSTOMERLISTEMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:CSCUSTOMERLISTEMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}



#pragma mark - 4.5.0 (获取客户列表)
- (void)getNewCustomerListForCustomerType:(NSString *)customerType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize attenInvestType:(NSString *)attenInvestType nameOrMobile:(NSString *)nameOrMobile
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                @autoreleasepool {
                    
                    self.myNewCustomerModel = [XNCSNewCustomerModel initNewMyCustomerListWithObject:self.dataDic];
                }
                [self notifyObservers:@selector(XNCustomerServerModuleNewCustomerListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCustomerServerModuleNewCustomerListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCustomerServerModuleNewCustomerListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCustomerServerModuleNewCustomerListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNCustomerServerModuleNewCustomerListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary *params = @{
                             @"token":token,
                             @"type":customerType,
                             @"pageIndex":pageIndex,
                             @"pageSize":pageSize,
                             //@"attenInvestType":attenInvestType,
                             @"nameOrMobile":nameOrMobile,
                             @"method":CSNEWCUSTOMERLISTMETHOD
                             };
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    if (attenInvestType.length > 0) {
        [dic setObject:attenInvestType forKey:@"attenInvestType"];
    }
    
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:dic];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:CSNEWCUSTOMERLISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//关注客户
- (void)careCustomer:(NSString *)userId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNCustomerServerModuleAddImprotantCustomerDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCustomerServerModuleAddImprotantCustomerDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCustomerServerModuleAddImprotantCustomerDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCustomerServerModuleAddImprotantCustomerDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNCustomerServerModuleAddImprotantCustomerDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"userId":userId,@"method":CSCUSTOMERADDIMPROTANTCUSTOMERMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:CSCUSTOMERADDIMPROTANTCUSTOMERMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 移除重要客户组
- (void)cancelCaredCustomer:(NSString *)customerId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNCustomerServerModuleRemoveImprotantCustomerDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCustomerServerModuleRemoveImprotantCustomerDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCustomerServerModuleRemoveImprotantCustomerDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCustomerServerModuleRemoveImprotantCustomerDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNCustomerServerModuleRemoveImprotantCustomerDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }

    NSDictionary * params = @{@"token":token,@"userId":customerId,@"method":CSCUSTOMERREMOVEIMPROTCUSTOMERMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:CSCUSTOMERREMOVEIMPROTCUSTOMERMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//关注理财师
- (void)careCfg:(NSString *)userId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNCustomerServerModuleCaredCfgDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCustomerServerModuleCaredCfgDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCustomerServerModuleCaredCfgDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCustomerServerModuleCaredCfgDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNCustomerServerModuleCaredCfgDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"userId":userId,@"method":CSCUSTOMERADDIMPROTANTCFGMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:CSCUSTOMERADDIMPROTANTCFGMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//取消关注客户
- (void)cancelCaredCfg:(NSString *)customerId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                [self notifyObservers:@selector(XNCustomerServerModuleCancelCaredCfgDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCustomerServerModuleCancelCaredCfgDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCustomerServerModuleCancelCaredCfgDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCustomerServerModuleCancelCaredCfgDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNCustomerServerModuleCancelCaredCfgDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"userId":customerId,@"method":CSCUSTOMERREMOVEIMPROTCFGMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:CSCUSTOMERREMOVEIMPROTCFGMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 获取顾客详情
- (void)getCustomerDetailForCustomer:(NSString *)userId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.customerDetailMode = [XNCSCustomerDetailMode initCustomerDetailWithObject:self.dataDic];
                [self notifyObservers:@selector(XNCustomerServerModuleCustomerDetailDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCustomerServerModuleCustomerDetailDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCustomerServerModuleCustomerDetailDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCustomerServerModuleCustomerDetailDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNCustomerServerModuleCustomerDetailDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"userId":userId,@"method":CSCUSTOMERDETAILMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:CSCUSTOMERDETAILMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//获取理财师成员详情
- (void)getCfgDetailForCfg:(NSString *)userId
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.cfgDetailMode = [XNCSCfgDetailMode initCfgDetailWithObject:self.dataDic];
                [self notifyObservers:@selector(XNCustomerServerModuleCfgDetailDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCustomerServerModuleCfgDetailDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCustomerServerModuleCfgDetailDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCustomerServerModuleCfgDetailDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNCustomerServerModuleCfgDetailDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"userId":userId,@"method":CSCFGDETAILMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:CSCFGDETAILMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

//获取客户详情中交易记录
- (void)getCustomerInvestRecordListForUserId:(NSString *)userId type:(NSString *)busType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.customerInvestRecordListMode = [XNCSMyCustomerInvestRecordListMode initWithObject:self.dataDic];
                [self notifyObservers:@selector(XNCustomerServerModuleCustomerInvestRecordListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCustomerServerModuleCustomerInvestRecordListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCustomerServerModuleCustomerInvestRecordListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCustomerServerModuleCustomerInvestRecordListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [self notifyObservers:@selector(XNCustomerServerModuleCustomerInvestRecordListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"userId":userId,@"type":busType,@"pageIndex":pageIndex,@"pageSize":pageSize,@"method":CSCUSTOMERINVESTRECORDLISTMETHOD};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:CSCUSTOMERINVESTRECORDLISTMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 回款日历 (4.5.0) <待回款>
- (void)loadWaitReturnMoneyListRepamentType:(NSString *)repamentType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize repamentTime:(NSString *)repamentTime
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.waitReturnMoneyListModel = [ReturnMoneyListModel initReturnMoneyItemWithObject:self.dataDic];
                
                [self notifyObservers:@selector(loadWaitReturnMoneyListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(loadWaitReturnMoneyListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(loadWaitReturnMoneyListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(loadWaitReturnMoneyListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        //[self notifyObservers:@selector(XNCustomerServerModuleGetExpireRedeemListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        //[[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,
                              @"pageIndex":pageIndex,
                              @"pageSize":pageSize,
                              @"repamentType":repamentType,
                              @"method":EXPIREREDEEMMETHOD
                              };
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    if (repamentTime.length > 0) {
        [mParams setObject:repamentTime forKey:@"repamentTime"];
    }
    
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:mParams];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:EXPIREREDEEMMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

// (已回款)
- (void)loadYetReturnMoneyListRepamentType:(NSString *)repamentType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize repamentTime:(NSString *)repamentTime
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.yetReturnMoneyListModel = [ReturnMoneyListModel initReturnMoneyItemWithObject:self.dataDic];
                
                [self notifyObservers:@selector(loadYetReturnMoneyListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(loadYetReturnMoneyListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(loadYetReturnMoneyListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(loadYetReturnMoneyListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
    
        return;
    }
    
    NSDictionary * params = @{@"token":token,
                              @"pageIndex":pageIndex,
                              @"pageSize":pageSize,
                              @"repamentType":repamentType,
                              @"method":EXPIREREDEEMMETHOD
                              };
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    if (repamentTime.length > 0) {
        [mParams setObject:repamentTime forKey:@"repamentTime"];
    }

    NSDictionary *signedParameter = [_LOGIC getSignParams:mParams];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:EXPIREREDEEMMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];

}

#pragma mark - 回款日历 (4.5.1) <具体某天的待回款>
- (void)loadDayWaitReturnMoneyListRepamentType:(NSString *)repamentType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize repamentTime:(NSString *)repamentTime
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.dayWaitReturnMoneyListModel = [ReturnMoneyListModel initReturnMoneyItemWithObject:self.dataDic];
                
                [self notifyObservers:@selector(loadDayWaitReturnMoneyListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(loadDayWaitReturnMoneyListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(loadDayWaitReturnMoneyListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(loadDayWaitReturnMoneyListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        //[self notifyObservers:@selector(XNCustomerServerModuleGetExpireRedeemListDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        //[[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,
                              @"pageIndex":pageIndex,
                              @"pageSize":pageSize,
                              @"repamentType":repamentType,
                              @"method":EXPIREREDEEMMETHOD
                              };
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    if (repamentTime.length > 0) {
        [mParams setObject:repamentTime forKey:@"repamentTime"];
    }
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:mParams];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:EXPIREREDEEMMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 回款日历 (4.5.1) <具体某天的已回款>
- (void)loadDayYetReturnMoneyListRepamentType:(NSString *)repamentType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize repamentTime:(NSString *)repamentTime
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                self.dayYetReturnMoneyListModel = [ReturnMoneyListModel initReturnMoneyItemWithObject:self.dataDic];
                
                [self notifyObservers:@selector(loadDayYetReturnMoneyListDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(loadDayYetReturnMoneyListDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(loadDayYetReturnMoneyListDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(loadDayYetReturnMoneyListDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        
        return;
    }
    
    NSDictionary * params = @{@"token":token,
                              @"pageIndex":pageIndex,
                              @"pageSize":pageSize,
                              //@"repamentType":repamentType,
                              @"method":EXPIREREDEEMMETHOD
                              };
    
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    if (repamentTime.length > 0) {
        [mParams setObject:repamentTime forKey:@"repamentTime"];
    }
    
    
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:mParams];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:EXPIREREDEEMMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}

#pragma mark - 根据环信账号获取用户信息
- (void)getUserInfoByEaseMob:(NSString *)easemobAcct
{
    void (^requestSuccessBlock)(id jsonData) = ^(id jsonData){
        if (jsonData) {
            self.retCode = [self convertRetJsonData:jsonData];
            
            if ([self.retCode.ret isEqualToString:@"0"]) {
                
                NSMutableArray * data = [NSMutableArray array];
                for (NSDictionary * dic in [self.dataDic objectForKey:@"datas"]) {
                    [data addObject:[XNIMUserInfoMode initIMUserInfoWithParams:dic]];
                }
                self.imUserInfoArray = data;
                
                [self notifyObservers:@selector(XNCustomerServerModuleGetUesrInfoByEasemobDidReceive:) withObject:self];
            }
            else {
                [self notifyObservers:@selector(XNCustomerServerModuleGetUserInfoByEasemobDidFailed:) withObject:self];
            }
        } else {
            [self notifyObservers:@selector(XNCustomerServerModuleGetUserInfoByEasemobDidFailed:) withObject:self];
        }
    };
    
    //请求失败block
    void (^requestFailureBlock)(NSError *error) = ^(NSError *error){
        
        [self convertRetWithError:error];
        [self notifyObservers:@selector(XNCustomerServerModuleGetUserInfoByEasemobDidFailed:) withObject:self];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
         [self notifyObservers:@selector(XNCustomerServerModuleGetUserInfoByEasemobDidFailed:) withObject:self];
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params = @{@"token":token,@"easemobAcct":easemobAcct};
    
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[EnvSwitchManager sharedClient] POST:[_LOGIC getShaRequestBaseUrl:CSIMEASEMOBMETHOD] parameters:signedParameter success:^(id operation, id responseObject) {
        
        requestSuccessBlock(responseObject);
        
    } failure:^(id operation, NSError *error) {
        
        requestFailureBlock(error);
    }];
}



@end
