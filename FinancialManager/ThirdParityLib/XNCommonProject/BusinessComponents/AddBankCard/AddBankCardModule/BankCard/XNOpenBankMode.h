//
//  XNGetBankCardInfoMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/17.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/* "bankCode": "BCOM",
 "bankId": 6,
 "bankName": "中国交通银行",
 "createTime": "2015-05-27 15:47:27",
 "dayLimitAmount": 10000000,
 "lastUpdateTime": "2015-05-27 15:47:27",
 "monthLimitAmount": 0,
 "providerName": "快钱支付",
 "recordLimitAmount": 2000000,
 "remark": "",
 "servicePhone": "95559",
 "status": 1
 }
*/

#define XN_ACCOUNT_BANKCARD_BANK_CODE @"bankCode"
#define XN_ACCOUNT_BANKCARD_BANK_NAME @"bankName"
#define XN_ACCOUNT_BANKCARD_BANK_ID   @"bankId"
#define XN_ACCOUNT_BANKCARD_CREATETIME @"createTime"
#define XN_ACCOUNT_BANKCARD_DAYLIMITAMOUNT @"dayLimitAmount"
#define XN_ACCOUNT_BANKCARD_LASTUPDATETIME @"lastUpdateTime"
#define XN_ACCOUNT_BANKCARD_MONTHLIMITAMOUNT @"monthLimitAmount"
#define XN_ACCOUNT_BANKCARD_PROVIDERNAME @"providerName"
#define XN_ACCOUNT_BANKCARD_RECORDLIMITAMOUNT @"recordLimitAmount"
#define XN_ACCOUNT_BANKCARD_REMARK @"remark"
#define XN_ACCOUNT_BANKCARD_SERVERPHONE @"servicePhone"
#define XN_ACCOUNT_BANKCARD_STATUS @"status"


@interface XNOpenBankMode : NSObject

@property (nonatomic, copy) NSString * bankCode;
@property (nonatomic, copy) NSString * bankName;
@property (nonatomic, copy) NSString * bankId;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * dayLimitAccount;
@property (nonatomic, copy) NSString * lastUpdateTime;
@property (nonatomic, copy) NSString * monthLimitAmount;
@property (nonatomic, copy) NSString * providerName;
@property (nonatomic, copy) NSString * recordLimitAmount;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * bankServicePhone;

+ (instancetype )initOpenBankModeWithObject:(NSDictionary *)params;
@end
