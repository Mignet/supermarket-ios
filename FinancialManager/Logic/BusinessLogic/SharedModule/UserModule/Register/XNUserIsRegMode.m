//
//  XNUserIsRegMode.m
//  FinancialManager
//
//  Created by xnkj on 15/12/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNUserIsRegMode.h"

#define XN_USER_ISREG_REGFLAG @"regFlag"
#define XN_USER_ISREG_REGSOURCE @"regSource"
#define XN_USER_ISREG_REGLIMIT @"regLimit"
#define XN_USER_ISREG_REGLIMITMSG @"regLimitMsg"

@implementation XNUserIsRegMode

+ (instancetype)initUserIsRegObjectWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNUserIsRegMode * pd = [[XNUserIsRegMode alloc]init];
        
        pd.regFlag = [params objectForKey:XN_USER_ISREG_REGFLAG];
        pd.regSource = [params objectForKey:XN_USER_ISREG_REGSOURCE];
        pd.isRegLimit = [[params objectForKey:XN_USER_ISREG_REGLIMIT] boolValue];
        pd.regLimitMsg = [params objectForKey:XN_USER_ISREG_REGLIMITMSG];
        
        return pd;
    }
    return nil;
}
@end
