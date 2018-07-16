//
//  XNFMProductCategoryStatisticMode.m
//  FinancialManager
//
//  Created by xnkj on 19/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNFMProductCategoryStatisticMode.h"

@implementation XNFMProductCategoryStatisticMode

+ (instancetype)initProductCategoryStatisticWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNFMProductCategoryStatisticMode * pd = [[XNFMProductCategoryStatisticMode alloc]init];
        
        pd.cateId = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FM_PRODUCT_CATEGORY_STATISTIC_CATEID]];
        pd.cateName = [params objectForKey:XN_FM_PRODUCT_CATEGORY_STATISTIC_CATENAME];
        pd.cateLog = [params objectForKey:XN_FM_PRODUCT_CATEGORY_STATISTIC_CATELOGO];
        pd.cateIcon = [params objectForKey:XN_FM_PRODUCT_CATEGORY_STATISTIC_CATELOGOINVESTOR];
        pd.content = [params objectForKey:XN_FM_PRODUCT_CATEGORY_STATISTIC_CONTENT];
        pd.productCount = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FM_PRODUCT_CATEGORY_STATISTIC_COUNT]];
        pd.timeLine = [params objectForKey:XN_FM_PRODUCT_CATEGORY_STATISTIC_DECLARE];
        pd.flowMaxStatic = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FM_PRODUCT_CATEGORY_STATISTIC_FLOWMAXRATESTATISTICS]];
        pd.flowMinStatic = [NSString stringWithFormat:@"%@",[params objectForKey:XN_FM_PRODUCT_CATEGORY_STATISTIC_FLOWMINRATESTATISTICS]];
        
        return pd;
    }
    return nil;
}

@end
