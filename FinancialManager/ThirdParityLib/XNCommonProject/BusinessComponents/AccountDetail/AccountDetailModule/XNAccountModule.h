//
//  XNAccountModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

#define XN_ACCOUNT_BANK_CANRD_CHARGE_NUMBER @"inRecordNo"
#define XN_ACCOUNT_MYACCOUNT_DETAIL_TYPE_DATA @"datas"

@class XNMyAccountInfoMode,XNAccountRecordListMode;
@interface XNAccountModule : AppModuleBase

@property (nonatomic, strong) XNMyAccountInfoMode     * myAccountMode;
@property (nonatomic, strong) NSArray                 * myAccountDetailTypeArray;
@property (nonatomic, strong) XNAccountRecordListMode * myAccountRecordListMode;

+ (instancetype)defaultModule;

/**
 * 我的账户
 **/
- (void)getMyAccountInfo;

/**
 *  账户明细
 *  params typeId 类型id
 *  params pageIndex 页标
 *  params pageSize 页大小
 **/
- (void)getMyAccountDetailListForTypeId:(NSString *)typeId PageIndex:(NSString *)pageIndex PageSize:(NSString *)pageSize;

@end
