//
//  XNComissionNewRecordMode.h
//  FinancialManager
//
//  Created by xnkj on 23/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_HOME_COMISSION_NEW_RECORD_DICTIONARY @"XN_HOME_COMISSION_NEW_RECORD_DICTIONARY"
#define XN_HOME_COMISSION_NEW_RECORD_ADDFEECOUPONUSEDETAIL @"addFeeCouponUseDetail"
#define XN_HOME_COMISSION_NEW_RECORD_FEEAMOUNT @"feeAmount"
#define XN_HOME_COMISSION_NEW_RECORD_FEERATE @"feeRate"
#define XN_HOME_COMISSION_NEW_RECORD_TYPE @"couponType"
#define XN_HOME_COMISSION_NEW_RECORD_HASNEWADDFEE @"hasNewAddFee"

@interface XNComissionNewRecordMode : NSObject

@property (nonatomic, strong) NSString * feeAmount;//加佣金额
@property (nonatomic, strong) NSString * feeRate;//佣金比例
@property (nonatomic, strong) NSString * couponType;
@property (nonatomic, assign) BOOL       hasNewAddFee;//是否有新的加佣券记录 0 没有 1 有

+ (instancetype)initComissionNewRecordWithParams:(NSDictionary *)params;
@end
