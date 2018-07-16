//
//  AsyCustomerListModule.m
//  FinancialManager
//
//  Created by xnkj on 09/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "AsyListModule.h"
#import "AsyListModuleObserver.h"

#import "XNCSMyCustomerListMode.h"
#import "XNCSNewCustomerModel.h"

#import "JFZDataBase.h"

#import "AsyCustomerLoadSession.h"
#import "AsyCfgLoadSession.h"

#import "NSObject+Common.h"

#define ASYCUSTOMERLISTMETHOD @"/customer/mycustomers/pageList"
#define ASYCFGLISTMETHOD @"/personcenter/cfplannerMemberPage"

#define XN_CS_MYCUSTOMERLIST_DATA       @"datas"
#define XN_CS_MYCUSTOMERLIST_PAGEINDEX @"pageIndex"
#define XN_CS_MYCUSTOMERLIST_PAGECOUNT @"pageCount"

@implementation AsyListModule

//获取客户列表
- (void)getCustomerListForCustomerName:(NSString *)name customerType:(NSString *)customerType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize sort:(NSString *)sort order:(NSString *)order
{
    weakSelf(weakSelf)
    void(^successBlock)(id operation, id responseObject) = ^(id operation, id responseObject){
        
        weakSelf.retCode = [self convertRetJsonData:operation];
        
        if ([weakSelf.retCode.ret isEqualToString:@"0"]) {
            
            weakSelf.customerPageIndex = [self.dataDic objectForKey:XN_CS_MYCUSTOMERLIST_PAGEINDEX];
            weakSelf.customerPageCount = [self.dataDic objectForKey:XN_CS_MYCUSTOMERLIST_PAGECOUNT];
             for (NSDictionary * params in [self.dataDic objectForKey:XN_CS_MYCUSTOMERLIST_DATA]){
                 
                 [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerDb"] inserDataWithParams:params WithTableName:@"CustomerList" success:^(id result, FMDatabase *db) {
                     
                 } failed:^(NSError *error) {
                     
                 }];
             }
            
            [weakSelf notifyObservers:@selector(asyCustomerListModuleGetCustomerListDidSuccess:) withObject:weakSelf];
        }else
        {
            [weakSelf notifyObservers:@selector(asyCustomerListModuleGetCustomerListDidFailed:) withObject:weakSelf];
        }
    };
    
    void(^failedBlock)(id response, NSError * error) = ^(id response, NSError * error){
    
         [weakSelf notifyObservers:@selector(asyCustomerListModuleGetCustomerListDidFailed:) withObject:weakSelf];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params=@{@"token":token,@"name":name,@"customerType":customerType,@"pageIndex":pageIndex,@"pageSize":pageSize,@"sort":sort,@"order":order,@"method":ASYCUSTOMERLISTMETHOD};
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[AsyCustomerLoadSession asyLoadInstance] POST:[_LOGIC getShaRequestBaseUrl:ASYCUSTOMERLISTMETHOD] parameters:signedParameter success:^(id operation, id response) {
        
        successBlock(operation, response);
        
    } failure:^(id response, NSError *error) {
        
        failedBlock(response, error);
    }];
}

//理财师列表
- (void)getNewCfgListPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize
{
    weakSelf(weakSelf)
    void(^successBlock)(id operation, id responseObject) = ^(id operation, id responseObject){
        
        weakSelf.retCode = [self convertRetJsonData:operation];
        
        if ([weakSelf.retCode.ret isEqualToString:@"0"]) {
        
            weakSelf.cfgPageIndex = [self.dataDic  objectForKey:XN_CS_MYCUSTOMERLIST_PAGEINDEX];
            weakSelf.cfgPageCount = [self.dataDic  objectForKey:XN_CS_MYCUSTOMERLIST_PAGECOUNT];
            for (NSDictionary * params in [self.dataDic objectForKey:XN_CS_MYCUSTOMERLIST_DATA]){
                
                [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerCfgDb"] inserDataWithParams:params WithTableName:@"CfgList" success:^(id result, FMDatabase *db) {
    
                } failed:^(NSError *error) {
    
                    NSLog(@"error:%@",error.description);
                }];
            }
            
            [weakSelf notifyObservers:@selector(asyCustomerListModuleGetCfgListDidSuccess:) withObject:weakSelf];
        }else
        {
            [weakSelf notifyObservers:@selector(asyCustomerListModuleGetCfgListDidFailed:) withObject:weakSelf];
        }
    };
    
    void(^failedBlock)(id response, NSError * error) = ^(id response, NSError * error){
        
        [weakSelf notifyObservers:@selector(asyCustomerListModuleGetCfgListDidFailed:) withObject:weakSelf];
    };
    
    NSString * token = [NSString decryptUseDES:[_LOGIC getValueForKey:XN_USER_TOKEN_TAG]];
    if (![NSObject isValidateInitString:token]) {
        
        [_LOGIC saveValueForKey:XN_USER_USER_TOKEN_EXPIRED Value:@"1"];
        [[NSNotificationCenter defaultCenter] postNotificationName:XNUSERLOGINNOTIFICATION object:nil];
        return;
    }
    
    NSDictionary * params=@{@"token":token,@"nameOrMobile":@"",@"attenInvestType":@"",@"type":@"1",@"pageIndex":pageIndex,@"pageSize":pageSize,@"method":ASYCFGLISTMETHOD};
    NSDictionary *signedParameter = [_LOGIC getSignParams:params];
    
    [[AsyCfgLoadSession asyLoadInstance] POST:[_LOGIC getShaRequestBaseUrl:ASYCFGLISTMETHOD] parameters:signedParameter success:^(id operation, id response) {
        
        successBlock(operation, response);
        
    } failure:^(id response, NSError *error) {
        
        failedBlock(response, error);
    }];
}

@end
