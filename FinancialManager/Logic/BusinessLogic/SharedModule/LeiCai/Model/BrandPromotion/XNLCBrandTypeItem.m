//
//  XNLCBrandTypeItem.m
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/6.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import "XNLCBrandTypeItem.h"

@implementation XNLCBrandTypeItem

+ (instancetype)brandTypeItem:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNLCBrandTypeItem *pd = [[XNLCBrandTypeItem alloc] init];
        
        pd.name = [params objectForKey:@"name"];
        pd.typeValue = [params objectForKey:@"typeValue"];
        pd.isChoose = NO;
        
        return pd;
    }
    
    return nil;
}

@end
