//
//  XNGrowthManualCategoryItemMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/31/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNGrowthManualCategoryItemMode.h"

@implementation XNGrowthManualCategoryItemMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNGrowthManualCategoryItemMode *pd = [[XNGrowthManualCategoryItemMode alloc] init];
        
        pd.nId = [NSString stringWithFormat:@"%@", [params objectForKey:XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_ID]];
        pd.img = [params objectForKey:XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_IMG];
        pd.title = [params objectForKey:XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_TITLE];
        pd.typeCode = [params objectForKey:XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_TYPECODE];
        pd.typeName = [params objectForKey:XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_TYPENAME];
        pd.readingAmount = [NSString stringWithFormat:@"%@", [params objectForKey:XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_READINGAMOUNT]];
        
        pd.shareIcon = [params objectForKey:XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_SHAREICON];
        pd.linkUrl = [params objectForKey:XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_LINKURL];
        pd.summary = [params objectForKey:XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_SUMMARY];
        
        return pd;
    }
    return nil;

}

@end
