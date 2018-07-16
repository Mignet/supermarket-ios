//
//  AsyCustomerListOperation.m
//  FinancialManager
//
//  Created by xnkj on 1/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "AsyCfgListOperation.h"

#import "XNCSNewCustomerModel.h"
#import "XNCSNewCustomerItemModel.h"
#import "AsyListModule.h"
#import "AsyListModuleObserver.h"

#import "JFZDataBase.h"

static inline NSString * AsyCfgLoadingKeyPathFromOperationState(AsyCfgLoadingStatus state) {
    switch (state) {
        case AsyCfgLoadingReadyState:
            return @"isReady";
        case AsyCfgLoadingExecutingState:
            return @"isExecuting";
        case AsyCfgLoadingFinishedState:
            return @"isFinished";
        case AsyCfgLoadingPausedState:
            return @"isPaused";
        default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            return @"state";
#pragma clang diagnostic pop
        }
    }
}

static inline BOOL AsyCfgLoadingStateTransitionIsValid(AsyCfgLoadingStatus fromState, AsyCfgLoadingStatus toState, BOOL isCancelled) {
    switch (fromState) {
        case AsyCfgLoadingReadyState:
            switch (toState) {
                case AsyCfgLoadingPausedState:
                case AsyCfgLoadingExecutingState:
                    return YES;
                case AsyCfgLoadingFinishedState:
                    return isCancelled;
                default:
                    return NO;
            }
        case AsyCfgLoadingExecutingState:
            switch (toState) {
                case AsyCfgLoadingPausedState:
                case AsyCfgLoadingFinishedState:
                    return YES;
                default:
                    return NO;
            }
        case AsyCfgLoadingFinishedState:
            return NO;
        case AsyCfgLoadingPausedState:
            return toState == AsyCfgLoadingReadyState;
        default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            switch (toState) {
                case AsyCfgLoadingPausedState:
                case AsyCfgLoadingReadyState:
                case AsyCfgLoadingExecutingState:
                case AsyCfgLoadingFinishedState:
                    return YES;
                default:
                    return NO;
            }
        }
#pragma clang diagnostic pop
    }
}



@interface AsyCfgListOperation()<AsyCustomerListmoduleObserver>

@property (nonatomic, strong)   AsyListModule * requstModule;
@property (nonatomic, assign) AsyCfgLoadingStatus status;

@property (nonatomic, assign) BOOL isRequestFinished;
@end

@implementation AsyCfgListOperation

- (id)init
{
    self = [super init];
    if (self) {
        
        self.status = AsyCfgLoadingReadyState;
        
    }
    return self;
}

//#pragma mark - overrider main(使用main的情况下，执行完main函数，线程就结束了。针对一些需要在线程中进行同步任务的处理，我们使用main进行处理。如果需要让main运行的线程保持阻塞状态，我们可以使用NSRunLoop阻塞线程的退出）
//- (void)main
//{
//    self.isRequestFinished = NO;
//    [[XNCustomerServerModule defaultModule] addObserver:self];
//    
//    NSDictionary * sqlKeyValueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"customerId",@"text",@"customerName",@"text",@"customerMobile",@"text",@"registerTime",@"text",@"nearInvestAmt",@"text",@"nearEndDate",@"text",@"currInvestAmt",@"text",@"totalInvestCount",@"bool",@"important",@"bool",@"readFlag",@"text",@"freecustomer",@"bool",@"sysImpFlag",@"text",@"easemobAcct",@"text",@"easemobPassword",@"bool",@"newRegist",@"text",@"image", nil];
//   
//    [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerDb"] clearAllDataInTable:@"CustomerList"];
//    [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerDb"] createDataBaseIfNotExistWithParams:sqlKeyValueDictionary primaryKey:@"customerId" tableName:@"CustomerList" shouldAutoIncrease:NO];
//    
//    [[XNCustomerServerModule defaultModule] getCustomerListForCustomerName:@"" customerType:@"" pageIndex:@"1" pageSize:@"30" sort:@"1" order:@"1"];
//    
//    [[NSRunLoop currentRunLoop] run];
//    
//    while(!self.isRequestFinished) {
//        
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
//}

#pragma mark -
- (void)start
{
    if([self isCancelled])
    {
        self.status = AsyCfgLoadingPausedState;
        return;
    }
    
    @autoreleasepool {
        
        NSDictionary * sqlKeyValueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"headImage",@"text",@"mobile",@"text",@"registTime",@"text",@"teamMemberCount",@"text",@"userId",@"text",@"userName",nil];
        
        [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerCfgDb"] clearAllDataInTable:@"CfgList"];
        [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerCfgDb"] createDataBaseIfNotExistWithParams:sqlKeyValueDictionary primaryKey:@"userId" tableName:@"CfgList" shouldAutoIncrease:NO];
        
        self.requstModule = [[AsyListModule alloc]init];
        [self.requstModule addObserver:self];
        [self.requstModule getNewCfgListPageIndex:@"1" pageSize:@"30"];
    }
    
    self.status = AsyCfgLoadingExecutingState;
}

- (void)setStatus:(AsyCfgLoadingStatus)status
{
    //查看当前网络状态变更是否有效
    if (! AsyCfgLoadingStateTransitionIsValid(self.status, status, [self isCancelled])) {
     
        return;
    }
    
    NSString * oldStatus = AsyCfgLoadingKeyPathFromOperationState(self.status);
    NSString * newStatus = AsyCfgLoadingKeyPathFromOperationState(status);
    [self willChangeValueForKey:newStatus];
    [self willChangeValueForKey:oldStatus];
    _status = status;
    [self didChangeValueForKey:newStatus];
    [self didChangeValueForKey:oldStatus];
}

#pragma mark - override isConcurrent//是否可以异步执行
- (BOOL)isReady {
    return self.status == AsyCfgLoadingReadyState && [super isReady];
}

- (BOOL)isExecuting {
    return self.status == AsyCfgLoadingExecutingState;
}

- (BOOL)isFinished {
    return self.status == AsyCfgLoadingFinishedState;
}

- (BOOL)isConcurrent {
    return YES;
}
///////////////
#pragma mark - protocal
////////////////////////////////////

#pragma mark - 客户列表拉取的数据回调
- (void)asyCustomerListModuleGetCfgListDidSuccess:(AsyListModule *)module
{
    if (module.cfgPageIndex.integerValue < module.cfgPageCount.integerValue) {
    
        [self.requstModule getNewCfgListPageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:module.cfgPageIndex.integerValue + 1]] pageSize:@"30"];
    }else
    {
        self.status = AsyCfgLoadingFinishedState;
        [self.requstModule removeObserver:self];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [[NSNotificationCenter defaultCenter] postNotificationName:XN_CFG_LIST_FINISHED_NOTIFICATION object:nil];
        });
    }
}

- (void)asyCustomerListModuleGetCfgListDidFailed:(AsyListModule *)module
{
    self.status = AsyCfgLoadingFinishedState;
    [self.requstModule removeObserver:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:XN_CFG_LIST_FINISHED_NOTIFICATION object:nil];
    });
}
@end
