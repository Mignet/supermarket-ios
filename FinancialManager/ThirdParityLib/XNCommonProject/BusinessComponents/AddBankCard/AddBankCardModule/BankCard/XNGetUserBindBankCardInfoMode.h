//
//  XNGetUserBindBankCardInfoMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/20.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/* bankCard	银行卡号	string
 bankName	银行名称	string
 idCard	身份证	string
 userName	用户名字	string	*/

#define XN_ACCOUNT_USERBINDBANKCARD_BANKCARD @"bankCard"
#define XN_ACCOUNT_USERBINDBANKCARD_BANK_NAME @"bankName"
#define XN_ACCOUNT_USERBINDBANKCARD_USER_NUMBER @"idCard"
#define XN_ACCOUNT_USERBINDBANKCARD_USER_NAME @"userName"
#define XN_ACCOUNT_USER_PHONE_NUMBER @"mobile"

@interface XNGetUserBindBankCardInfoMode : NSObject

@property (nonatomic, strong) NSString * bankCard;
@property (nonatomic, strong) NSString * bankName;
@property (nonatomic, strong) NSString * idCard;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userPhoneNumber;

+ (instancetype )initUserBindBankCardInfoWithObject:(NSDictionary *)params;
@end
