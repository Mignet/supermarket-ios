//
//  XNMIMyProfitDetailStatisticMode.h
//  FinancialManager
//
//  Created by xnkj on 1/13/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MYINFO_MYPROFIT_DETAIL_STATISTIC_TOTALPROFIT @"total"

@interface XNMIMyProfitDetailStatisticMode : NSObject

@property (nonatomic, strong) NSString * totalProfit;

+ (instancetype )initMyProfitDetailStatisticWithParams:(NSDictionary *)params;
@end
