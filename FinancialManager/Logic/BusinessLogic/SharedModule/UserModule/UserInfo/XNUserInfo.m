//
//  XNUserInfo.m
//  FinancialManager
//
//  Created by xnkj on 15/11/4.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNUserInfo.h"

@implementation XNUserInfo

+ (instancetype )initUserWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNUserInfo * pd = [[XNUserInfo alloc]init];
        
        pd.cfgBeNormalTime = [params objectForKey:XN_USERINFO_CFGBENORMAL_TIME];
        pd.cfgLevel = [params objectForKey:XN_USERINFO_CFGLEVEL];
        pd.cfgLevelName = [params objectForKey:XN_USERINFO_CFGLEVELNAME];
        pd.cfgRegTime = [params objectForKey:XN_USERINFO_CFGREGTIME];
        pd.cfgUpdateTime = [params objectForKey:XN_USERINFO_CFGUPDATETIME];
        
        pd.mobile = [params objectForKey:XN_USERINFO_MOBILE];
        pd.userName = [params objectForKey:XN_USERINFO_USERNAME];
        
        pd.partnerLevel = [params objectForKey:XN_USERINFO_PARTNERLEVEL];
        pd.partnerlevelName = [params objectForKey:XN_USERINFO_PARTNERLEVELNAME];
        pd.partnerRegTime = [params objectForKey:XN_USERINFO_PARTNERREGTIME];
        pd.partnerUpdateTime = [params objectForKey:XN_USERINFO_PARTNERUPTIME];
        pd.easemobAccount = [params objectForKey:XN_USERINFO_EASEMOBACCT];
        pd.easemobPassword = [params objectForKey:XN_USERINFO_EASEMOBPASSWORD];
        
        return pd;
    }
    return nil;
}
@end
