//
//  InvestStatisticsModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/29.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvestStatisticsModel : NSObject

@property (nonatomic, copy) NSString *feeAmountSumTotal;

@property (nonatomic, copy) NSString *investAmtTotal;

@property (nonatomic, copy) NSString *havaRepaymentAmtTotal;

@property (nonatomic, copy) NSString *waitRepaymentAmtTotal;

@property (nonatomic, strong) NSMutableArray *calendarStatisticsResponseList;

+ (instancetype)investStatisticsModelWithParams:(NSDictionary *)params;

@end

 /***
 data =     {
 calendarStatisticsResponseList =         (
 {
 calendarNumber = 2;
 calendarTime = "2017-11-01";
 },
 {
 calendarNumber = 48;
 calendarTime = "2017-11-02";
 },
 {
 calendarNumber = 25;
 calendarTime = "2017-11-03";
 },
 {
 calendarNumber = 1;
 calendarTime = "2017-11-04";
 },
 {
 calendarNumber = 33;
 calendarTime = "2017-11-06";
 },
 {
 calendarNumber = 65;
 calendarTime = "2017-11-07";
 },
 {
 calendarNumber = 18;
 calendarTime = "2017-11-08";
 },
 {
 calendarNumber = 2;
 calendarTime = "2017-11-21";
 }
 );
 feeAmountSumTotal = "14379.07";
 investAmtTotal = "293482.00";
 };
 
 **/
