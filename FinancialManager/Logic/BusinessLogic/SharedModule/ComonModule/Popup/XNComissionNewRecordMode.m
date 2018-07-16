//
//  XNComissionNewRecordMode.m
//  FinancialManager
//
//  Created by xnkj on 23/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNComissionNewRecordMode.h"

@implementation XNComissionNewRecordMode

+ (instancetype)initComissionNewRecordWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        [_LOGIC saveNSDictionary:params key:XN_HOME_COMISSION_NEW_RECORD_DICTIONARY];
        
        XNComissionNewRecordMode * pd = [[XNComissionNewRecordMode alloc]init];
        
        pd.feeAmount = [NSString stringWithFormat:@"%@",[[params objectForKey:XN_HOME_COMISSION_NEW_RECORD_ADDFEECOUPONUSEDETAIL] objectForKey:XN_HOME_COMISSION_NEW_RECORD_FEEAMOUNT]];
        pd.feeRate = [NSString stringWithFormat:@"%@",[[params objectForKey:XN_HOME_COMISSION_NEW_RECORD_ADDFEECOUPONUSEDETAIL] objectForKey:XN_HOME_COMISSION_NEW_RECORD_FEERATE]];
        
        pd.couponType = [NSString stringWithFormat:@"%@",[[params objectForKey:XN_HOME_COMISSION_NEW_RECORD_ADDFEECOUPONUSEDETAIL] objectForKey:XN_HOME_COMISSION_NEW_RECORD_TYPE]];
        
        pd.hasNewAddFee = [[params objectForKey:XN_HOME_COMISSION_NEW_RECORD_HASNEWADDFEE] boolValue];

        return pd;
    }
    return nil;
}
@end
