//
//  RankCalcLevelMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 5/24/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RANK_CALC_LEVEL_MODE_CREATE_TIME @"createTime"
#define RANK_CALC_LEVEL_MODE_LEVEL_CODE @"levelCode"
#define RANK_CALC_LEVEL_MODE_LEVEL_NAME @"levelName"
#define RANK_CALC_LEVEL_MODE_LEVEL_REMARK @"levelRemark"
#define RANK_CALC_LEVEL_MODE_LEVEL_WEIGHT @"levelWeight"

@interface RankCalcLevelMode : NSObject

@property (nonatomic, copy) NSString *createTime; //创建时间
@property (nonatomic, copy) NSString *levelCode; //职级代码
@property (nonatomic, copy) NSString *levelName; //职级名称
@property (nonatomic, copy) NSString *levelRemark; //职级描述
@property (nonatomic, assign) NSInteger levelWeight; //职级权重 (见习=10 | 顾问=20 | 经理=30 | 总监=40)

+ (instancetype)initWithParams:(NSDictionary *)params;

@end
