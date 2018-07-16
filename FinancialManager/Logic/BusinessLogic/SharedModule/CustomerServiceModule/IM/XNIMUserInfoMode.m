//
//  XNIMUserInfoMode.m
//  FinancialManager
//
//  Created by xnkj on 16/1/7.
//  Copyright © 2016年 xiaoniu. All rights reserved.
//

#import "XNIMUserInfoMode.h"

@implementation XNIMUserInfoMode

+ (instancetype )initIMUserInfoWithParams:(NSDictionary *)params
{
    if (params) {
        
        XNIMUserInfoMode * pd = [[XNIMUserInfoMode alloc]init];
        
        pd.userId = [params objectForKey:XN_CS_IM_USERINFO_USERID];
        pd.userName = [params objectForKey:XN_CS_IM_USERINFO_USERNAME];
        pd.mobile = [params objectForKey:XN_CS_IM_USERINFO_MOBILE];
        pd.userPic = [params objectForKey:XN_CS_IM_USERINFO_USERPIC];
        pd.easemobAccount = [params objectForKey:XN_CS_IM_USERINFO_EASEMOBACCOUNT];
        
        return pd;
    }
    return nil;
}
@end
