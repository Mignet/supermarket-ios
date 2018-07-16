//
//  XNFMInviedListStaticsMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNCSInviedListStaticsMode.h"

@implementation XNCSInviedListStaticsMode

+ (instancetype )initInvitedListStaticsWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNCSInviedListStaticsMode * pd = [[XNCSInviedListStaticsMode alloc]init];
        
        pd.InvitedPersons  = [params objectForKey:XN_FMINVITEDLIST_STATISTIC_RCPERSONS];
        pd.RegisterPersons = [params objectForKey:XN_FMINVITEDLIST_STATISTIC_REGPERSONS];
        
        return pd;
    }
    return nil;
}
@end
