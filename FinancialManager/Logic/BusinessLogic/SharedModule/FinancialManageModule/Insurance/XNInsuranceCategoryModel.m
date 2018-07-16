//
//  XNInsuranceCategoryModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/2.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import "XNInsuranceCategoryModel.h"

@implementation XNInsuranceCategoryModel

+ (instancetype)createInsuranceCategoryModel:(NSDictionary *)params
{
    if (params) {
        
        XNInsuranceCategoryModel * pd = [[XNInsuranceCategoryModel alloc] init];
        
        pd.category = [params objectForKey:@"category"];
        pd.message = [params objectForKey:@"message"];
        
        return pd;
    }
    return nil;
    
}

@end
