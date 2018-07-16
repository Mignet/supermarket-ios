//
//  AsyCustomerListOperation.m
//  FinancialManager
//
//  Created by xnkj on 1/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "AsyCustomerListOperation.h"

#import "XNCSMyCustomerListMode.h"
#import "AsyListModule.h"
#import "AsyListModuleObserver.h"

#import "JFZDataBase.h"

static inline NSString * AsyCustomerLoadingKeyPathFromOperationState(AsyCustomerLoadingStatus state) {
    switch (state) {
        case AsyCustomerLoadingReadyState:
            return @"isReady";
        case AsyCustomerLoadingExecutingState:
            return @"isExecuting";
        case AsyCustomerLoadingFinishedState:
            return @"isFinished";
        case AsyCustomerLoadingPausedState:
            return @"isPaused";
        default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            return @"state";
#pragma clang diagnostic pop
        }
    }
}

static inline BOOL AsyCustomLoadingStateTransitionIsValid(AsyCustomerLoadingStatus fromState, AsyCustomerLoadingStatus toState, BOOL isCancelled) {
    switch (fromState) {
        case AsyCustomerLoadingReadyState:
            switch (toState) {
                case AsyCustomerLoadingPausedState:
                case AsyCustomerLoadingExecutingState:
                    return YES;
                case AsyCustomerLoadingFinishedState:
                    return isCancelled;
                default:
                    return NO;
            }
        case AsyCustomerLoadingExecutingState:
            switch (toState) {
                case AsyCustomerLoadingPausedState:
                case AsyCustomerLoadingFinishedState:
                    return YES;
                default:
                    return NO;
            }
        case AsyCustomerLoadingFinishedState:
            return NO;
        case AsyCustomerLoadingPausedState:
            return toState == AsyCustomerLoadingReadyState;
        default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            switch (toState) {
                case AsyCustomerLoadingPausedState:
                case AsyCustomerLoadingReadyState:
                case AsyCustomerLoadingExecutingState:
                case AsyCustomerLoadingFinishedState:
                    return YES;
                default:
                    return NO;
            }
        }
#pragma clang diagnostic pop
    }
}



@interface AsyCustomerListOperation()<AsyCustomerListmoduleObserver>

@property (nonatomic, strong) NSLock * lock;
@property (nonatomic, strong)   AsyListModule * requstModule;
@property (nonatomic, assign) AsyCustomerLoadingStatus status;

@property (nonatomic, assign) BOOL isRequestFinished;
@end

@implementation AsyCustomerListOperation

- (id)init
{
    self = [super init];
    if (self) {
        
        self.lock = [[NSLock alloc] init];
        self.status = AsyCustomerLoadingReadyState;
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
        self.status = AsyCustomerLoadingPausedState;
        return;
    }
    
    @autoreleasepool {
        
        
        NSDictionary * sqlKeyValueDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"text",@"easemobAcct",@"text",@"firstLetter",@"text",@"freecustomer",@"text",@"headImage",@"bool",@"important",@"text",@"isRead",@"text",@"mobile",@"text",@"nearEndDate",@"text",@"nearInvestAmt",@"text",@"nearInvestDate",@"text",@"registerTime",@"text",@"totalInvestAmt",@"text",@"totalInvestCount",@"text",@"userId",@"text",@"userName",nil];
        
        [self.lock lock];
        [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerDb"] clearAllDataInTable:@"CustomerList"];
        [[JFZDataBase shareDataBaseWithDBName:@"FinancialManagerDb"] createDataBaseIfNotExistWithParams:sqlKeyValueDictionary primaryKey:@"customerId" tableName:@"CustomerList" shouldAutoIncrease:NO];
        [self.lock unlock];
        
        self.requstModule = [[AsyListModule alloc]init];
        [self.requstModule addObserver:self];
        [self.requstModule getCustomerListForCustomerName:@"" customerType:@"" pageIndex:@"1" pageSize:@"30" sort:@"1" order:@"1"];
        
    }
    
    self.status = AsyCustomerLoadingExecutingState;
}

- (void)setStatus:(AsyCustomerLoadingStatus)status
{
    //查看当前网络状态变更是否有效
    if (! AsyCustomLoadingStateTransitionIsValid(self.status, status, [self isCancelled])) {
     
        return;
    }
    
    NSString * oldStatus = AsyCustomerLoadingKeyPathFromOperationState(self.status);
    NSString * newStatus = AsyCustomerLoadingKeyPathFromOperationState(status);
    [self willChangeValueForKey:newStatus];
    [self willChangeValueForKey:oldStatus];
    _status = status;
    [self didChangeValueForKey:newStatus];
    [self didChangeValueForKey:oldStatus];
}

#pragma mark - override isConcurrent//是否可以异步执行
- (BOOL)isReady {
    return self.status == AsyCustomerLoadingReadyState && [super isReady];
}

- (BOOL)isExecuting {
    return self.status == AsyCustomerLoadingExecutingState;
}

- (BOOL)isFinished {
    return self.status == AsyCustomerLoadingFinishedState;
}

- (BOOL)isConcurrent {
    return YES;
}
///////////////
#pragma mark - protocal
////////////////////////////////////

#pragma mark - 客户列表拉取的数据回调
- (void)asyCustomerListModuleGetCustomerListDidSuccess:(AsyListModule *)module
{
    
    if (module.customerPageIndex.integerValue < module.customerPageCount.integerValue) {
    
        [self.requstModule getCustomerListForCustomerName:@"" customerType:@"" pageIndex:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:module.customerPageIndex.integerValue + 1]] pageSize:@"30" sort:@"1" order:@"1"];
    }else
    {
        self.status = AsyCustomerLoadingFinishedState;
        [self.requstModule removeObserver:self];
    }
}

- (void)XNCustomerServerModuleCustomerListDidFailed:(AsyListModule *)module
{
    self.status = AsyCustomerLoadingFinishedState;
    [self.requstModule removeObserver:self];
}
@end
