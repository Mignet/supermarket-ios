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

@class XNGetUserBindBankCardInfoMode,XNBankCardMode;
@interface XNAddBankCardModule : AppModuleBase

@property (nonatomic, strong) NSArray     * openBankListArray;
@property (nonatomic, strong) XNBankCardMode  * bankCardMode;
@property (nonatomic, strong) XNGetUserBindBankCardInfoMode * userBindCardInfoMode;
@property (nonatomic, strong) NSString * bankCardNumberStr;
@property (nonatomic, strong) NSString * userNameStr;
@property (nonatomic, strong) NSString * idNumberStr;

+ (instancetype)defaultModule;

/**
 * 查询
 * */
- (void)getAllBankInfo;

/**
 * 添加银行卡
 * params bankCard 绑卡号
 * params bankCode 卡编号
 * params bankId。卡id
 * params bankName 银行名
 * params idCard。身份证
 * params mobile  手机号
 * params userName 用户名
 **/
- (void)addBankCardWithBankCardNumber:(NSString *)bankCard idCard:(NSString *)idCard mobile:(NSString *)mobile userName:(NSString *)userName;

/**
 * 查看用户绑卡信息
 **/
- (void)getUserBindBankCardInfo;

/**
 * 上传银行卡图片
 * params bankCardImage 图片实体
 **/
- (void)uploadBankCardImage:(UIImage *)bankCardImage;

/**
 * 上传身份证图片
 * params idCardImage 图片实体
 **/
- (void)uploadIdCardImage:(UIImage *)idCardImage;
@end
