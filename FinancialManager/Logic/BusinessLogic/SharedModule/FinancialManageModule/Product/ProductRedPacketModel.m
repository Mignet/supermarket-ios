//
//  ProductRedPacketModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/25.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import "ProductRedPacketModel.h"
#import "ProductRedPacketItemModel.h"

@implementation ProductRedPacketModel

+ (instancetype)initWithProductRedPacketModelParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        ProductRedPacketModel *pd = [[ProductRedPacketModel alloc] init];
        
        NSMutableArray *datas = [NSMutableArray arrayWithCapacity:0];
        NSArray *modelArr = [params objectForKey:@"datas"];
        for (NSDictionary *dic in modelArr) {
            ProductRedPacketItemModel *item = [ProductRedPacketItemModel initWithProductRedPacketItemModelParams:dic];
            
            [datas addObject:item];
        }
        
        pd.datas = datas;
        
        return pd;
    }
    
    return nil;
}

@end
