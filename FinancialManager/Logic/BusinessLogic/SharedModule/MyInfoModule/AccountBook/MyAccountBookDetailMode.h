//
//  MyAccountBookDetailMode.h
//  FinancialManager
//
//  Created by xnkj on 19/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MYACCOUNTBOOK_DETAIL_INVESTOTAL @"investTotal"
#define XN_MYACCOUNTBOOK_DETAIL_INVESTTOTALAMT @"investTotalAmt"
#define XN_MYACCOUNTBOOK_DETAIL_INVESTTOTALPROFIT @"investTotalProfit"

@interface MyAccountBookDetailMode : NSObject

@property (nonatomic, strong) NSString * investTotal;
@property (nonatomic, strong) NSString * investAmount;
@property (nonatomic, strong) NSString * investProfit;

+ (instancetype)initAccountBookDetailWithParams:(NSDictionary *)params;
@end
