//
//  DeportMoneyModule.h
//  XNCommonProject
//
//  Created by xnkj on 4/26/16.
//  Copyright © 2016 lhkj. All rights reserved.
//

#import "AppModuleBase.h"

@class XNWithDrawBankCardInfoMode,XNMyAccountTotalDeportMode,XNMyAccountDeportRecordListMode;
@interface DeportMoneyModule : AppModuleBase

@property (nonatomic, strong) NSDictionary                    * userBindBankCardinfoDictionary;
@property (nonatomic, strong) XNWithDrawBankCardInfoMode      * withDrawBankCardInfoMode;
@property (nonatomic, strong) NSArray                         * provinceInfoArray;
@property (nonatomic, strong) NSArray                         * cityInfoArray;
@property (nonatomic, strong) XNMyAccountTotalDeportMode      * myAccountTotalDeportMode;
@property (nonatomic, strong) XNMyAccountDeportRecordListMode * myAccountDeportRecordListMode;

+ (instancetype)defaultModule;

/**
 *  查询银行卡信息
 **/
- (void)requestBindBankCardInfo;


/**
 *  查询省份
 **/
- (void)requestProvinceInfo;

/**
 *  查询城市
 *  params provinceCode 身份Code
 **/
- (void)requestCityInfoWithProvinceCode:(NSString *)proviceCode;

/**
 *  提款
 *  params name 用户名字
 *  params idCardNo 身份证号码
 *  params amount 金额
 *  params bankCode 银行卡编号
 *  params bankName 银行名称
 *  params city 城市名
 *  params kaiHuHang 开户行
 **/
- (void)requestWithDrawWithBankCard:(NSString *)bankCard bankName:(NSString *)bankName city:(NSString *)city kaiHuHang:(NSString *)kaihuhang amount:(NSString *)amount;

/**
 * 查询用户累计提现
 **/
- (void)getMyAccountTotalDeportMoney;

/**
 *  获取提现明细
 *  params pageIndex 页标
 *  params pageSize  页码
 **/
- (void)getmyAccountDeportRecordListAtIndex:(NSString *)pageIndex PageSize:(NSString *)pageSize;
@end
