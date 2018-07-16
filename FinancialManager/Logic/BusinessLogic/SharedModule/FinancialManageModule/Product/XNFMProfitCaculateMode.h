//
//  XNFMProfitCaculateMode.h
//  FinancialManager
//
//  Created by xnkj on 1/28/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/* "fee":"50.00"
 * "reward":"50.00"  //销售奖励
 * “otherProfit": “20.00”, //其他收益
 *  "sum": “70.00”//合计
 *  "profitType": ["销售奖励","活动奖励"], //其他收益类型名称
*/

#define XN_FM_PRODUCT_DETAIL_PROFITCACULATE_OTHERPROFIT @"profiltValue"
#define XN_FM_PRODUCT_DETAIL_PROFITCACULATE_NAME @"profiltName"
#define XN_FM_PRODUCT_DETAIL_PROFITCACULATE_PROFITTYPE @"profiltType"
#define XN_FM_PRODUCT_DETAIL_PROFITCACULATE_ISEDIT @"isEdit"

@interface XNFMProfitCaculateMode : NSObject

@property (nonatomic, strong) NSString * profitValue;
@property (nonatomic, strong) NSString * profitName;
@property (nonatomic, strong) NSString * profitType;
@property (nonatomic, assign) BOOL       canEdit;

+ (instancetype)initProfitCaculateWithParams:(NSDictionary *)params;
@end
