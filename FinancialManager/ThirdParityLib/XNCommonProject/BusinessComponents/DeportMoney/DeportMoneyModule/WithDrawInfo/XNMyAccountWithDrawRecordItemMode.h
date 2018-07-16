//
//  NXMyAccountDeportRecordItemMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*"outRecordNo": "2015000000069845", //提现流水号
 "partnerId": "10001", //业务方id
 "userId": "4931ec49-a6c3-49be-bd83-ff014dcee13e", //用户id
 "userName": "李峰",  //用户姓名
 "bisName": "提现", //业务名称
 "bisTime": "2015-08-18 16:13:08", //提现时间
 "totalAmount": 123000, //提现金额
 "amount": 123000, //实际到账金额
 "fee": 0, //手续费
 "status": "1" //提现处理状态
*/

#define XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_USERID      @"userId"
#define XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_USERNAME    @"userName"
#define XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_BISNAME     @"bisName"
#define XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_BISTIME     @"paymentDate"
#define XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_TRANSDATE   @"transDate"
#define XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_AMOUNT      @"amount"
#define XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_FEE         @"fee"
#define XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_STATUS      @"status"
#define XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_USERTYPE    @"userType"
#define XN_ACCOUNT_MYACCOUNT_RECORD_ITEM_FAILURE_CAUSE @"remark"

@interface XNMyAccountWithDrawRecordItemMode : NSObject

@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * bisName;
@property (nonatomic, strong) NSString * paymentDate;
@property (nonatomic, strong) NSString * transDate;
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * fee;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * userType;
@property (nonatomic, strong) NSString * failureCause;

+ (instancetype )initWithDrawRecordItemWithObject:(NSDictionary *)params;
@end
