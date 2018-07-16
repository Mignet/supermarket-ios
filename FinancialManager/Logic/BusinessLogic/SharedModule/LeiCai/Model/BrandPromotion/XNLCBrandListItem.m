//
//  XNLCBrandListItem.m
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/6.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import "XNLCBrandListItem.h"

@implementation XNLCBrandListItem

+ (instancetype)createBrandListItem:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNLCBrandListItem *pd = [[XNLCBrandListItem alloc] init];
        
        pd.image = [params objectForKey:@"image"];
        pd.smallImage = [params objectForKey:@"smallImage"];
        pd.isChoose = NO;
        
        return pd;
        
    }

    return nil;
}

@end
