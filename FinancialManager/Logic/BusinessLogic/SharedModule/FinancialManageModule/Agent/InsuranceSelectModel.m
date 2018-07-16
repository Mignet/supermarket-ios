//
//  InsuranceSelectModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/29.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "InsuranceSelectModel.h"
#import "XNInsuranceItem.h"

@implementation InsuranceSelectModel

+ (instancetype)initInsuranceSelectModelWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        InsuranceSelectModel *mode = [[InsuranceSelectModel alloc] init];
        
        XNInsuranceItem *itemMode = nil;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in [params objectForKey:@"datas"])
        {
            itemMode = [XNInsuranceItem initInsuranceWithParams:dic];
            [array addObject:itemMode];
        }
        mode.datas = array;
        return mode;
        
    }
    return nil;
}

@end
