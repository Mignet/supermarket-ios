//
//  SeekTreasureRecommendListModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekTreasureRecommendListModel.h"
#import "SeekTreasureReadItemModel.h"

@implementation SeekTreasureRecommendListModel

+ (instancetype)initSeekTreasureRecommendListModelWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        SeekTreasureRecommendListModel * pd = [[SeekTreasureRecommendListModel alloc]init];
        
        pd.datas = [[NSMutableArray alloc] init];
        SeekTreasureReadItemModel * mode = nil;
        for (NSDictionary * param in [params objectForKey:@"datas"]) {
            
            mode = [SeekTreasureReadItemModel initSeekTreasureReadItemModelParams:param];
            [pd.datas addObject:mode];
        }
        
        return pd;
    }
    
    return nil;
}

@end
