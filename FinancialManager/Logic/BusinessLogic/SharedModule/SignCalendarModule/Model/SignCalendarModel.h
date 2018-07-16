//
//  SignCalendarModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Sign_Calendar_Model_datas @"datas"

@interface SignCalendarModel : NSObject

@property (nonatomic, copy) NSString *year;

@property (nonatomic, copy) NSString *month;

@property (nonatomic, strong) NSMutableArray *data;

+ (instancetype)signCalendarModelWithParams:(NSDictionary *)params;

@end
