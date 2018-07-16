//
//  XNFMInviedListStaticsMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNInviedListStaticsMode.h"

@implementation XNInviedListStaticsMode

+ (instancetype )initInvitedListStaticsWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNInviedListStaticsMode * pd = [[XNInviedListStaticsMode alloc]init];
        
        pd.InvitedPersons  = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FMINVITEDLIST_STATISTIC_RCPERSONS]];
        pd.RegisterPersons = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FMINVITEDLIST_STATISTIC_REGPERSONS] ];
        
        return pd;
    }
    return nil;
}
@end
