//
//  SeekTreasureRecommendListModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeekTreasureRecommendListModel : NSObject

@property (nonatomic, strong) NSMutableArray *datas;

+ (instancetype)initSeekTreasureRecommendListModelWithParams:(NSDictionary *)params;

@end
