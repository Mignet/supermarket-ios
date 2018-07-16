//
//  QquestionResultRecomListItem.m
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/6.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import "QquestionResultRecomListItem.h"

// categoryImage = ee3dd86e92bf9da9e1e971433e680c1e;
// recomCategory = 5;

@implementation QquestionResultRecomListItem

+ (instancetype)createResultRecomListItemWithPramas:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        QquestionResultRecomListItem *pd = [[QquestionResultRecomListItem alloc] init];
        
        pd.categoryImage = [params objectForKey:@"categoryImage"];
        pd.recomCategory = [params objectForKey:@"recomCategory"];
        
        return pd;
    }
    
    return nil;
    
}

@end
