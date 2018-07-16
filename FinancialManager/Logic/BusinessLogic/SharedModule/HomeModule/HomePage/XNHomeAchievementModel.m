//
//  XNHomeAchievementModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/25.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "XNHomeAchievementModel.h"

@implementation XNHomeAchievementModel

+ (instancetype)createXNHomeAchievementModel:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNHomeAchievementModel *pd = [[XNHomeAchievementModel alloc] init];
        pd.activeUserNumber = [params objectForKey:@"activeUserNumber"];
        pd.commissionAmount = [params objectForKey:@"commissionAmount"];
        pd.reInvestRate = [params objectForKey:@"reInvestRate"];
        pd.safeOperationTime = [NSString stringWithFormat:@"%@", [params objectForKey:@"safeOperationTime"]];
        
        return pd;
    }
    return nil;
}

@end
