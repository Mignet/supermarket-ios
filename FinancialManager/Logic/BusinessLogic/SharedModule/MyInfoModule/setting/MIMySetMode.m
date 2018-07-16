//
//  MIMySetMode.m
//  FinancialManager
//
//  Created by xnkj on 15/11/2.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "MIMySetMode.h"

@implementation MIMySetMode

+ (instancetype )initMySetWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        MIMySetMode * pd = [[MIMySetMode alloc]init];
        
        pd.bundBankCard = [[params objectForKey:XN_MYINFO_SETTING_BUNBANKCARD] boolValue];
        pd.onceMoreBindCard = [[params objectForKey:XN_MYINFO_ONCEMORE_BINDCARD] boolValue];
        
        return pd;
    }
    return nil;
}
@end
