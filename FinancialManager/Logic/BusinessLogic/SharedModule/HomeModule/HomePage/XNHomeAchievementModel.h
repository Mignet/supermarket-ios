//
//  XNHomeAchievementModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/25.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNHomeAchievementModel : NSObject

// 活跃理财师人数
@property (nonatomic, copy) NSString *activeUserNumber;

// 累计发放佣金(元)
@property (nonatomic, copy) NSString *commissionAmount;

// 平均每月复投率
@property (nonatomic, copy) NSString *reInvestRate;

// 安全运营天数
@property (nonatomic, copy) NSString *safeOperationTime;

+ (instancetype)createXNHomeAchievementModel:(NSDictionary *)params;

@end
