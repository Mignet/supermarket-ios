//
//  XNHomeBannerMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNHomeBannerMode.h"

@implementation XNHomeBannerMode

+ (instancetype )initBannerWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNHomeBannerMode * pd = [[XNHomeBannerMode alloc]init];
        
        pd.imgUrl = [params objectForKey:XN_HOMEPAGE_BANNER_IMG_URL];
        pd.linkUrl = [params objectForKey:XN_HOMEPAGE_BANNER_LINK_URL];
        pd.title = [params objectForKey:XN_HOMEPAGE_BANNER_TITLE];
        pd.desc = [params objectForKey:XN_HOMEPAGE_BANNER_DESC];
        pd.link = [params objectForKey:XN_HOMEPAGE_BANNER_LINK];
        pd.icon = [params objectForKey:XN_HOMEPAGE_BANNER_ICON];
        
        return pd;
    }
    return nil;
}
@end
