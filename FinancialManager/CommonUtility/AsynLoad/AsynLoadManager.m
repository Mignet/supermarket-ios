//
//  AsynLoad.m
//  FinancialManager
//
//  Created by xnkj on 1/26/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "AsynLoadManager.h"

#import "AsyCustomerListOperation.h"
#import "AsyCfgListOperation.h"

#import "IMManager.h"

#import "XNCustomerServerModule.h"
#import "XNCSMyCustomerListMode.h"
#import "XNCustomerServerModuleObserver.h"

@interface AsynLoadManager()<XNCustomerServerModuleObserver>

@property (nonatomic, strong) NSOperationQueue * operationQueue;
@end

@implementation AsynLoadManager

+ (instancetype)defaultAsynLoadManager
{
    static AsynLoadManager * manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        manager = [[AsynLoadManager alloc]init];
    });
    
    return manager;
}

#pragma mark - 加载客户列表
- (void)loadCustomerList
{
    AsyCustomerListOperation * operation = [[AsyCustomerListOperation alloc]init];
    [self.operationQueue addOperation:operation];
}

//加载理财师列表
- (void)loadCfgList
{
    AsyCfgListOperation * operation = [[AsyCfgListOperation alloc]init];
    [self.operationQueue addOperation:operation];
}

/////////////////////
#pragma mark - setter/getter
////////////////////////////////////

#pragma mark - operationQueue
- (NSOperationQueue *)operationQueue
{
    if (!_operationQueue) {
        
        _operationQueue = [[NSOperationQueue alloc]init];
        [_operationQueue setMaxConcurrentOperationCount:5];
    }
    return _operationQueue;
}

@end
