//
//  MIAccountBalanceDetailListMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 2/14/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_AMOUNT @"amount"
#define XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_REMARK @"remark"
#define XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_TRAN_NAME @"tranName"
#define XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_USER_TYPE @"userType"
#define XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_TRAN_TIME @"tranTime"
#define XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_STATUS @"status"
#define XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_WITHDRAW_REMARK @"withdrawRemark"
#define XN_ACCOUNT_BALANCE_DETAIL_ITEM_MODE_FAILURE_CAUSE @"failureCause"

@interface MIAccountBalanceDetailItemMode : NSObject

@property (nonatomic, copy) NSString *amount; //交易金额
@property (nonatomic, copy) NSString *remark; //备注
@property (nonatomic, copy) NSString *tranName; //交易名称
@property (nonatomic, copy) NSString *userType; //区分那个端（T呗、猎财）
@property (nonatomic, copy) NSString *tranTime; //交易时间
@property (nonatomic, copy) NSString *status; //提现状态（1=提现中| 2、8=已提交银行，待到账| 3审核不通过| 5=提现成功| 、6、7=提现失败）
@property (nonatomic, copy) NSString *withdrawRemark; //提现备注（支出）
@property (nonatomic, copy) NSString *failureCause; //提现失败原因

+ (instancetype )initWithObject:(NSDictionary *)params;

@end
