//
//  XNInsuranceQquestionResultModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/6.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import "XNInsuranceQquestionResultModel.h" 
#import "QquestionResultRecomListItem.h"

@implementation XNInsuranceQquestionResultModel

+ (instancetype)createQquestionResultModelWithParams:(NSDictionary *)params;
{
    if ([NSObject isValidateObj:params]) {
    
        XNInsuranceQquestionResultModel *pd = [[XNInsuranceQquestionResultModel alloc] init];
        
        pd.riskGrade = [params objectForKey:@"riskGrade"];
        pd.totalScore = [params objectForKey:@"totalScore"];
        
        pd.data = [NSMutableArray arrayWithCapacity:0];
        NSArray *recomList = [params objectForKey:@"recomList"];
        
        for (NSDictionary *listDic in recomList) {
            
            QquestionResultRecomListItem *item = [QquestionResultRecomListItem createResultRecomListItemWithPramas:listDic];
            
            [pd.data addObject:item];
        }
        return pd;
    }
    
    return nil;
}

@end
