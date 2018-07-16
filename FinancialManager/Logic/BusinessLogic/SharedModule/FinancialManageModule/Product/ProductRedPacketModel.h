//
//  ProductRedPacketModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/25.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductRedPacketModel : NSObject

@property (nonatomic, strong) NSMutableArray *datas;

+ (instancetype)initWithProductRedPacketModelParams:(NSDictionary *)params;

@end
