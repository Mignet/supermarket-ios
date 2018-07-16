//
//  XNRecommondListMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 10/17/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNRecommendListMode.h"
#import "XNRecommendItemMode.h"

@implementation XNRecommendListMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNRecommendListMode *mode = [[XNRecommendListMode alloc] init];

        mode.orgIsstaticproduct = [[params objectForKey:XN_RECOMMOND_LIST_MODE_ORG_ISSTATIC_PRODUCT] integerValue];
        if (mode.orgIsstaticproduct == 0)
        {
            XNRecommendItemMode *itemMode2 = nil;
            NSMutableArray *array2 = [NSMutableArray array];
            for (NSDictionary *dic in [params objectForKey:XN_RECOMMOND_LIST_MODE_HAVE_FEE_LIST])
            {
                itemMode2 = [XNRecommendItemMode initWithObject:dic];
                [array2 addObject:itemMode2];
            }
            mode.haveFeeList = array2;
            
            XNRecommendItemMode *itemMode3 = nil;
            NSMutableArray *array3 = [NSMutableArray array];
            for (NSDictionary *dic in [params objectForKey:XN_RECOMMOND_LIST_MODE_NOT_HAVE_FEE_LIST])
            {
                itemMode3 = [XNRecommendItemMode initWithObject:dic];
                [array3 addObject:itemMode3];
            }
            mode.notHaveFeeList = array3;
        }
        else
        {
            XNRecommendItemMode *itemMode1 = nil;
            NSMutableArray *array1 = [NSMutableArray array];
            NSArray *array = [params objectForKey:XN_RECOMMOND_LIST_MODE_ALL_FEE_LIST];
            if (![array isEqual:@""])
            {
                for (NSDictionary *dic in [params objectForKey:XN_RECOMMOND_LIST_MODE_ALL_FEE_LIST])
                {
                    itemMode1 = [XNRecommendItemMode initWithObject:dic];
                    [array1 addObject:itemMode1];
                }
                mode.allFeeList = array1;
            }
            
        }
        return mode;
    }
    return nil;
}

@end
