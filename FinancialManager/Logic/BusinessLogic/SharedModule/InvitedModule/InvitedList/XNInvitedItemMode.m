//
//  XNFMInvitedListItemMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNInvitedItemMode.h"

@implementation XNInvitedItemMode

+ (instancetype)initInvitedItemWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNInvitedItemMode * pd = [[XNInvitedItemMode alloc] init];
        pd.userName = [params objectForKey:XN_FM_INVITEDLIST_ITEM_USERNAME];
        pd.registerTime = [params objectForKey:XN_FM_INVITEDLIST_ITEM_REGISTERDATE];
        pd.mobile = [params objectForKey:XN_FM_INVITEDLIST_ITEM_CUSTOMPHONE];
        pd.isInvest = [params objectForKey:XN_FM_INVITEDLIST_ITEM_INVESTFLAGE];
        pd.haveInvitation = [params objectForKey:XN_FM_INVITEDLIST_ITEM_HAVEINVITATION];
        
        return pd;
    }
    return nil;
}
@end
