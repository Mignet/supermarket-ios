//
//  XNInvitedContactMode.m
//  FinancialManager
//
//  Created by xnkj on 15/12/28.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNInvitedContactMode.h"

@implementation XNInvitedContactMode

+ (instancetype )initInvitedContactWithParams:(NSDictionary *)params
{
    if (params) {
        
        XNInvitedContactMode * pd = [[XNInvitedContactMode alloc]init];
        
        pd.content = [params objectForKey:XN_INVITED_CONTACT_CONTENT];
        pd.allowedInvitedCustomer = [params objectForKey:XN_INVIRED_CONTACT_ALLOW_INVITED_CUSTOMERS];
        
        return pd;
    }
    return nil;
}
@end
