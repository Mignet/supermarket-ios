//
//  SeekTreasureHotActivityModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/20.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeekTreasureHotActivityModel : NSObject

@property (nonatomic, strong) NSMutableArray *datas;

+ (instancetype)initSeekTreasureHotActivityModelWithParams:(NSDictionary *)params;

@end
