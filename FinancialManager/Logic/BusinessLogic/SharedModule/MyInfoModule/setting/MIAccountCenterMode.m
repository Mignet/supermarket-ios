//
//  MIAccountCenterMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 6/22/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "MIAccountCenterMode.h"

@implementation MIAccountCenterMode

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        MIAccountCenterMode *mode = [[MIAccountCenterMode alloc] init];
        mode.authenName = [params objectForKey:MI_MYINFO_ACCOUNT_CENTER_MODE_AUTHENNAME];
        mode.bankCard = [params objectForKey:MI_MYINFO_ACCOUNT_CENTER_MODE_BANKCARD];
        mode.headImage = [params objectForKey:MI_MYINFO_ACCOUNT_CENTER_MODE_HEADIMAGE];
        mode.mobile = [params objectForKey:MI_MYINFO_ACCOUNT_CENTER_MODE_MOBILE];
        return mode;
    }
    return nil;
}

@end
