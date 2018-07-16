//
//  XNBundSelectTypeMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/18/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNBundSelectTypeMode.h"

@implementation XNBundSelectTypeMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNBundSelectTypeMode *mode = [[XNBundSelectTypeMode alloc] init];
        mode.delStatus = [params objectForKey:XN_BUND_SELECT_TYPE_MODE_DELSTATUS];
        mode.fundType = [params objectForKey:XN_BUND_SELECT_TYPE_MODE_FUND_TYPE];
        mode.fundTypeKey = [params objectForKey:XN_BUND_SELECT_TYPE_MODE_FUND_TYPE_KEY];
        mode.fundTypeName = [params objectForKey:XN_BUND_SELECT_TYPE_MODE_FUND_TYPE_NAME];
        mode.fundTypeValue = [params objectForKey:XN_BUND_SELECT_TYPE_MODE_FUND_TYPE_VALUE];
        mode.bId = [params objectForKey:XN_BUND_SELECT_TYPE_MODE_ID];
        mode.orgNumber = [params objectForKey:XN_BUND_SELECT_TYPE_MODE_ORGNUMBER];
        
        return mode;
    }
    return nil;
}

@end
