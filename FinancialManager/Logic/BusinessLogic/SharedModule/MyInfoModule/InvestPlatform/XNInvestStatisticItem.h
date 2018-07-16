//
//  XNInvestStatisticIitem.h
//  FinancialManager
//
//  Created by xnkj on 16/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MYINFO_INVEST_STATISTIC_ITEM_ORGNAME @"orgName"
#define XN_MYINFO_INVEST_STATISTIC_ITEM_TOTALPERCENT @"totalPercent"

@interface XNInvestStatisticItem : NSObject

@property (nonatomic, strong) NSString * orgName;
@property (nonatomic, strong) NSString * totalPercent;

+ (XNInvestStatisticItem *)initInvestStatistItemWithParams:(NSDictionary *)params;
@end
