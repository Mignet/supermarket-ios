//
//  XNInvitedCustomerMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/16.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNCSInvitedCustomerMode.h"

@implementation XNCSInvitedCustomerMode

+ (instancetype )initInvitedCustomerWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNCSInvitedCustomerMode * pd = [[XNCSInvitedCustomerMode alloc]init];
        
        pd.codeUrl = [params objectForKey:XN_CS_INVITED_CUSTOMER_CODEURL];
        pd.sharedTitle = [[params objectForKey:XN_CS_INVITED_CUSTOMER_SHAREDCONTENT] objectForKey:XN_CS_INVITED_CUSTOMER_SHARED_TITLE];
        pd.sharedDescription = [[params objectForKey:XN_CS_INVITED_CUSTOMER_SHAREDCONTENT] objectForKey:XN_CS_INVITED_CUSTOMER_SHARED_DESCRIPTION];
        pd.sharedLink = [[params objectForKey:XN_CS_INVITED_CUSTOMER_SHAREDCONTENT] objectForKey:XN_CS_INVITED_CUSTOMER_SHARED_LINK];
        pd.sharedImageUrl = [[params objectForKey:XN_CS_INVITED_CUSTOMER_SHAREDCONTENT] objectForKey:XN_CS_INVITED_CUSTOMER_SHARED_IMGURL];
        
        return pd;
    }
    return nil;
}
@end
