//
//  XNPlatformUserCenter.m
//  FinancialManager
//
//  Created by ancye.Xie on 9/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNPlatformUserCenterOrProductMode.h"

@implementation XNPlatformUserCenterOrProductMode

+ (instancetype )initWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNPlatformUserCenterOrProductMode *mode = [[XNPlatformUserCenterOrProductMode alloc] init];
        mode.orgAccount = [params objectForKey:XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_ORG_ACCOUNT];
        mode.orgKey = [params objectForKey:XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_ORG_KEY];
        mode.orgNumber = [params objectForKey:XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_ORG_NUMBER];
        mode.sign = [params objectForKey:XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_SIGN];
        mode.timestamp = [params objectForKey:XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_TIMESTAMP];
        mode.requestFrom = [params objectForKey:XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_REQUEST_FROM];
        
        mode.orgUsercenterUrl = [params objectForKey:XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_ORG_USER_CENTER_URL];
        
        mode.orgProductUrl = [params objectForKey:XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_ORG_PRODUCT_URL];
        mode.thirdProductId = [params objectForKey:XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_THIRD];
        mode.txId = [params objectForKey:XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_TXID];
        
        return mode;
    }
    return nil;
}

@end
