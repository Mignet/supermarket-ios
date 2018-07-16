//
//  InsuranceBannerModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/28.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "InsuranceBannerModel.h"
#import "XNHomeBannerMode.h"

@implementation InsuranceBannerModel

+ (instancetype)initInsuranceBannerModelWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        InsuranceBannerModel *mode = [[InsuranceBannerModel alloc] init];
        
        XNHomeBannerMode *itemMode = nil;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in [params objectForKey:@"datas"])
        {
            itemMode = [XNHomeBannerMode initBannerWithObject:dic];
            [array addObject:itemMode];
        }
        mode.datas = array;
        return mode;
        
    }
    return nil;
}

@end
