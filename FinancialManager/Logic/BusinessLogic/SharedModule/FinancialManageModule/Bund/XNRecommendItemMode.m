//
//  XNRecommondItemMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 10/17/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNRecommendItemMode.h"

@implementation XNRecommendItemMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNRecommendItemMode *mode = [[XNRecommendItemMode alloc] init];
        mode.userName = [params objectForKey:XN_RECOMMOND_ITEM_MODE_USERNAME];
        mode.mobile = [params objectForKey:XN_RECOMMOND_ITEM_MODE_MOBILE];
        mode.userId = [params objectForKey:XN_RECOMMOND_ITEM_MODE_USERID];
        mode.headImage = [params objectForKey:XN_RECOMMOND_ITEM_MODE_HEADIMAGE];
        mode.ifRecommend = [[params objectForKey:XN_RECOMMOND_ITEM_MODE_IS_RECOMMEND] integerValue];
        
        return mode;
    }
    return nil;
}

@end
