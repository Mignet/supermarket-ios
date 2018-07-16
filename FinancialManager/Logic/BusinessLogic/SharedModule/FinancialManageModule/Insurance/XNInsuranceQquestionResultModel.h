//
//  XNInsuranceQquestionResultModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/6.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNInsuranceQquestionResultModel : NSObject


@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, copy) NSString *riskGrade;

@property (nonatomic, copy) NSString *totalScore;

+ (instancetype)createQquestionResultModelWithParams:(NSDictionary *)params;

@end
