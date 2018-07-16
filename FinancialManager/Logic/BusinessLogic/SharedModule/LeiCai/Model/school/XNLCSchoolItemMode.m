//
//  XNLCSchoolItemMode.m
//  FinancialManager
//
//  Created by xnkj on 07/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNLCSchoolItemMode.h"

@implementation XNLCSchoolItemMode

+ (instancetype)initLCSchoolItemWithParams:(NSDictionary *)parmas
{
    if ([NSObject isValidateObj:parmas]) {
        
        XNLCSchoolItemMode * pd = [[XNLCSchoolItemMode alloc]init];
        
        pd.schoolId = [parmas objectForKey:XN_LC_SCHOOL_ITEM_ID];
        pd.createTime = [parmas objectForKey:XN_LC_SCHOOL_ITEM_CREATE_TIME];
        pd.img = [parmas objectForKey:XN_LC_SCHOOL_ITEM_IMG];
        pd.label = [parmas objectForKey:XN_LC_SCHOOL_ITEM_LABEL];
        pd.summary = [parmas objectForKey:XN_LC_SCHOOL_SUMMARY];
        pd.linkUrl = [parmas objectForKey:XN_LC_SCHOOL_ITEM_LINKURL];
        pd.title = [parmas objectForKey:XN_LC_SCHOOL_ITEML_TITLE];
        pd.shareDesc = [parmas objectForKey:XN_LC_AGENT_ACTIVITY_SHAREDESC];
        pd.shareIcon = [parmas objectForKey:XN_LC_AGENT_ACTIVITY_SHAREICON];
        pd.shareLink = [parmas objectForKey:XN_LC_SCHOOL_ITEM_LINKURL];
        pd.shareTitle = [parmas objectForKey:XN_LC_AGENT_ACTIVITY_SHAREDTITLE];
        
        return pd;
    }

    return nil;
}
@end
