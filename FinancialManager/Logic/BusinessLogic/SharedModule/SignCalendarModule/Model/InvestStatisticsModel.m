//
//  InvestStatisticsModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/29.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "InvestStatisticsModel.h"
#import "InvestStatisticsItemModel.h"

@implementation InvestStatisticsModel

+ (instancetype)investStatisticsModelWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        InvestStatisticsModel *pd = [[InvestStatisticsModel alloc] init];
        
        if ([NSObject isValidateObj:[params objectForKey:@"feeAmountSumTotal"]]) {
            pd.feeAmountSumTotal = [params objectForKey:@"feeAmountSumTotal"];
        }
        
        if ([NSObject isValidateObj:[params objectForKey:@"investAmtTotal"]]) {
            pd.investAmtTotal = [params objectForKey:@"investAmtTotal"];
        }
        
        if ([NSObject isValidateObj:[params objectForKey:@"havaRepaymentAmtTotal"]]) {
            pd.havaRepaymentAmtTotal = [params objectForKey:@"havaRepaymentAmtTotal"];
        }
        
        if ([NSObject isValidateObj:[params objectForKey:@"waitRepaymentAmtTotal"]]) {
            pd.waitRepaymentAmtTotal = [params objectForKey:@"waitRepaymentAmtTotal"];
        }
        
        InvestStatisticsItemModel * mode = nil;
        NSMutableArray * recordListArr = [NSMutableArray array];
        NSArray * datas = [params objectForKey:@"calendarStatisticsResponseList"];
        for (NSInteger index = 0 ; index < datas.count; index ++ ) {
            
            mode = [InvestStatisticsItemModel investStatisticsItemModelWithParams:[datas objectAtIndex:index]];
            [recordListArr addObject:mode];
        }
        
        pd.calendarStatisticsResponseList = recordListArr;
        
        return pd;
    }
    return nil;
}

@end

