//
//  AsyCustomerListModule.h
//  FinancialManager
//
//  Created by xnkj on 09/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModuleBase.h"

@class XNCSMyCustomerListMode,XNCSNewCustomerModel;
@interface AsyListModule : AppModuleBase

@property (nonatomic, strong) NSString * cfgPageIndex;
@property (nonatomic, strong) NSString * cfgPageCount;
@property (nonatomic, strong) NSString * customerPageIndex;
@property (nonatomic, strong) NSString * customerPageCount;

/**
 * 获取客户列表
 * params name 客户姓名、电话号码
 * params customerType 客户类型-1表示投资客户,2表示未投资客户，3表示重要客户，为空表示全部
 * params pageIndex 页标
 * params pageSize 页大小
 * params sort 排序字段1:投资额；2:注册时间3:投资时间；4:到期时间；5:姓名)
 * params order 排序方式: (1:降序，2:升序)
 **/
- (void)getCustomerListForCustomerName:(NSString *)name customerType:(NSString *)customerType pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize sort:(NSString *)sort order:(NSString *)order;

/***
 * 获取客户列表 (4.5.0)
 * params pageIndex 页标
 * params pageSize 页大小
 **/
- (void)getNewCfgListPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;
@end
