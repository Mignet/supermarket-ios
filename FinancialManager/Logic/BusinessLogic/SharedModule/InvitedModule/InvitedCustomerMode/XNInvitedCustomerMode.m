//
//  XNInvitedCustomerMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/16.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNInvitedCustomerMode.h"

@implementation XNInvitedCustomerMode

+ (instancetype )initInvitedCustomerWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNInvitedCustomerMode * pd = [[XNInvitedCustomerMode alloc]init];
        
        pd.codeUrl = [params objectForKey:XN_MI_INVITED_CUSTOMER_CODEURL];
        pd.sharedTitle = [[params objectForKey:XN_MI_INVITED_CUSTOMER_SHAREDCONTENT] objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_TITLE];
        pd.sharedDescription = [[params objectForKey:XN_MI_INVITED_CUSTOMER_SHAREDCONTENT] objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_DESCRIPTION];
        pd.sharedLink = [[params objectForKey:XN_MI_INVITED_CUSTOMER_SHAREDCONTENT] objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_LINK];
        pd.sharedImageUrl = [[params objectForKey:XN_MI_INVITED_CUSTOMER_SHAREDCONTENT] objectForKey:XN_MI_INVITED_CUSTOMER_SHARED_IMGURL];
        
        return pd;
    }
    return nil;
}
@end
