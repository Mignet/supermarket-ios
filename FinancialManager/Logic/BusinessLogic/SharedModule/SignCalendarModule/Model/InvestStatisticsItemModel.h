//
//  InvestStatisticsItemModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/29.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvestStatisticsItemModel : NSObject

@property (nonatomic, copy) NSString *calendarNumber;

@property (nonatomic, copy) NSString *calendarTime;

@property (nonatomic, copy) NSString *year;

@property (nonatomic, copy) NSString *month;

@property (nonatomic, copy) NSString *day;

+ (instancetype)investStatisticsItemModelWithParams:(NSDictionary *)params;

@end

/**
 calendarNumber = 2;
 calendarTime = "2017-11-01";
**/
