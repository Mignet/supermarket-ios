//
//  XNUserVerifyIdentifyMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/12.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNUserVerifyIdentifyMode.h"

@implementation XNUserVerifyIdentifyMode

+ (instancetype)initUserVerifyIdentifyWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNUserVerifyIdentifyMode * pd = [[XNUserVerifyIdentifyMode alloc]init];
        
        pd.result = [[params objectForKey:XN_USER_VERIFYIDENTIFY] boolValue];
        
        return pd;
    }
    return nil;
}
@end
