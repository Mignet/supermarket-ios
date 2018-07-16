//
//  SeekActivityListModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekActivityListModel.h"
#import "SeekActivityItemModel.h"

@implementation SeekActivityListModel

+ (instancetype )initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        SeekActivityListModel *pd = [[SeekActivityListModel alloc] init];
        
        pd.pageIndex = [params objectForKey:@"pageIndex"];
        pd.pageSize = [params objectForKey:@"pageSize"];
        pd.pageCount = [params objectForKey:@"pageCount"];
        pd.totalCount = [params objectForKey:@"totalCount"];
        
        SeekActivityItemModel * mode = nil;
        NSMutableArray * redPacketArray = [NSMutableArray array];
        NSArray * datas = [params objectForKey:@"datas"];
        for (NSInteger index = 0 ; index < datas.count; index ++ ) {
            
            mode = [SeekActivityItemModel initWithObject:[datas objectAtIndex:index]];
            [redPacketArray addObject:mode];
        }
        pd.datas = redPacketArray;
        
        return pd;
    }
    return nil;
}


@end
