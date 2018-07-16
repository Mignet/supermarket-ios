//
//  XNCSCfgItemMode.m
//  FinancialManager
//
//  Created by xnkj on 24/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNCSCfgItemMode.h"

@implementation XNCSCfgItemMode
+ (instancetype)initCSCfgItemWithParams:(NSDictionary *)parmas
{
    if ([NSObject isValidateObj:parmas]) {
        
        XNCSCfgItemMode * pd = [[XNCSCfgItemMode alloc]init];
        
        pd.headImage = [parmas objectForKey:XN_CS_CFG_HEADIMAGE];
        pd.mobile  = [parmas objectForKey:XN_CS_CFG_MOBILE];
        pd.registTime  = [parmas objectForKey:XN_CS_CFG_REGISTTIME];
        pd.teamMemberCount = [parmas objectForKey:XN_CS_CFG_TEAMMEMBERCOUNT];
        pd.userName = [parmas objectForKey:XN_CS_CFG_USERNAME];
        pd.userId = [parmas objectForKey:XN_CS_CFG_USERID];
        
        return pd;
    }
    return nil;
}
@end
