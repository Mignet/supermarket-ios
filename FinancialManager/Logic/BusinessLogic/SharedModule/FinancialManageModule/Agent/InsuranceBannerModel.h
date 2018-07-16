//
//  InsuranceBannerModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/12/28.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsuranceBannerModel : NSObject

@property (nonatomic, strong) NSArray *datas;

+ (instancetype)initInsuranceBannerModelWithObject:(NSDictionary *)params;

@end
