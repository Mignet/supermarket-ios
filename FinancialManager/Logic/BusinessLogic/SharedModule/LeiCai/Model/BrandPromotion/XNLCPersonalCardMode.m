//
//  XNLCPersonalCardMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 6/28/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNLCPersonalCardMode.h"

@implementation XNLCPersonalCardMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNLCPersonalCardMode *pd = [[XNLCPersonalCardMode alloc] init];
        
        pd.mobile = [params objectForKey:XNCL_PERSONAL_CARD_MODE_MOBILE];
        pd.qrcode = [params objectForKey:XNCL_PERSONAL_CARD_MODE_QRCODE];
        pd.userName = [params objectForKey:XNCL_PERSONAL_CARD_MODE_USERNAME];
        return pd;
    }
    return nil;
}

@end
