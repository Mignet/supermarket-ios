//
//  XNGrowthManualCategoryMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/31/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNGrowthManualCategoryMode.h"

@implementation XNGrowthManualCategoryMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNGrowthManualCategoryMode *pd = [[XNGrowthManualCategoryMode alloc] init];
        
        pd.icon = [params objectForKey:XN_GROWTH_MANUAL_CATEGORY_MODE_ICON];
        pd.name = [params objectForKey:XN_GROWTH_MANUAL_CATEGORY_MODE_NAME];
        pd.cateId = [params objectForKey:XN_GROWTH_MANUAL_CATEGORY_MODE_CATEID];
        pd.desc = [params objectForKey:XN_GROWTH_MANUAL_CATEGORY_MODE_DESC];
        
        return pd;
    }
    return nil;
}

@end
