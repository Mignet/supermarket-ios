//
//  XNRemindPopMode.m
//  FinancialManager
//
//  Created by xnkj on 08/05/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNRemindPopMode.h"

@implementation XNRemindPopMode

+ (instancetype)initRemindPopWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNRemindPopMode * pd = [[XNRemindPopMode alloc]init];
        
        pd.cfpLevelTitle = [params objectForKey:XN_HOME_REMIDN_POP_CFPLEVELTITLE];
        pd.cfpLevelContent = [params objectForKey:XN_HOME_REMIND_POP_CFPLEVELCONTENT];
        pd.cfpLevelDetail = [params objectForKey:XN_HOME_REMIND_POP_CFPLEVELDETAIL];
        
        pd.systemTime = [params objectForKey:XN_HOME_REMIND_POP_NOW];
        
        return pd;
    }
    return nil;
}
@end
