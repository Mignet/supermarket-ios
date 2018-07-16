//
//  SeekTreasureHotActivityModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekTreasureHotActivityModel.h"
#import "SeekTreasureHotActivityItemModel.h"

@implementation SeekTreasureHotActivityModel

+ (instancetype)initSeekTreasureHotActivityModelWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        SeekTreasureHotActivityModel * pd = [[SeekTreasureHotActivityModel alloc]init];
        
        pd.datas = [[NSMutableArray alloc]init];
        SeekTreasureHotActivityItemModel * mode = nil;
        for (NSDictionary * param in [params objectForKey:@"datas"]) {
            
            mode = [SeekTreasureHotActivityItemModel initSeekTreasureHotActivityItemModelParams:param];
            [pd.datas addObject:mode];
        }

        return pd;
    }
    
    return nil;
}

@end
