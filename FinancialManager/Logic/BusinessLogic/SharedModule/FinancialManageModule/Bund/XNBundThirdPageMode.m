//
//  XNBundThirdPageMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 8/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNBundThirdPageMode.h"

@implementation XNBundThirdPageMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNBundThirdPageMode *mode = [[XNBundThirdPageMode alloc] init];
        mode.data = [params objectForKey:XN_BUND_THIRD_PAGE_MODE_DATA];
        mode.integrationMode = [params objectForKey:XN_BUND_THIRD_PAGE_MODE_INTEGRATIONMODE];
        mode.productCode = [params objectForKey:XN_BUND_THIRD_PAGE_MODE_PRODUCT_CODE];
        mode.referral = [params objectForKey:XN_BUND_THIRD_PAGE_MODE_REFERRAL];
        mode.requestUrl = [params objectForKey:XN_BUND_THIRD_PAGE_MODE_REQUEST_URL];
        
        return mode;
    }
    
    return nil;
    
}

@end
