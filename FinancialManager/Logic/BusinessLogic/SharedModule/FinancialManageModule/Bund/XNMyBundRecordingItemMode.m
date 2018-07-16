//
//  XNMyBundRecordingItemMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/22/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNMyBundRecordingItemMode.h"

@implementation XNMyBundRecordingItemMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNMyBundRecordingItemMode *mode = [[XNMyBundRecordingItemMode alloc] init];
        mode.accountNumber = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_ACCOUNT_NUMBER];
        mode.fundCode = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_FUND_CODE];
        mode.fundName = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_FUND_NAME];
        mode.merchantdouble = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_MERCHANT_NUMBER];
        mode.orderDate = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_ORDER_DATE];
        mode.portfolioId = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_PORTFOLIOID];
        mode.rspId = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_RSPID];
        mode.transactionAmount = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_AMOUNT];
        mode.transactionCharge = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_CHARGE];
        mode.transactionDate = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_DATE];
        mode.transactionRate = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_RATE];
        mode.transactionStatus = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_STATUS];
        mode.transactionStatusMsg = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_STATUS_MSG];
        mode.transactionType = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_TYPE];
        mode.transactionTypeMsg = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_TYPE_MSG];
        mode.transactionUnit = [params objectForKey:XN_MYBUND_RECORDING_ITEM_MODE_TRANSACTION_UNIT];
        
        return mode;
    }
    return nil;
}

@end
