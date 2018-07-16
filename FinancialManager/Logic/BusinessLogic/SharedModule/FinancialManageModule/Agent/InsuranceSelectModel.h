//
//  InsuranceSelectModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/29.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsuranceSelectModel : NSObject

@property (nonatomic, strong) NSArray *datas;

+ (instancetype)initInsuranceSelectModelWithParams:(NSDictionary *)params;

@end
