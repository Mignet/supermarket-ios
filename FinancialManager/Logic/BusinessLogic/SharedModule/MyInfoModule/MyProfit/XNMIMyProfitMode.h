//
//  XNMIMyProfitMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*“
 “minDate”:”2015-08-12”,//收益记录最小时间
 “dayProfit”:”888.18”,//今日收益
 “sumProfit”:”888.65”,//本月收益
 “totalProfit”:”895.53”,//累计收益
 “itemss”:[{//收益项
 “profitName”:”推荐津贴”,//收益项名称
 “profitType”:”1001”,//收益项id
 “amt”:”500.52”//金额
 }…]
*/

#define XN_MYINFO_MYPROFIT_MINTIME @"minDate"
#define XN_MYINFO_MYPROFIT_DAYPROFIT @"dayProfit"
#define XN_MYINFO_MYPROFIT_MONTHPROFIT @"sumProfit"
#define XN_MYINFO_MYPROFIT_TOTALPROFIT @"totalProfit"
#define XN_MYINFO_MYPROFIT_PROFITS @"items"
#define XN_MYINFO_MYPROFIT_PROFITS_PROFINAME @"profitName"
#define XN_MYINFO_MYPROFIT_PROFITS_PROFITTYPE @"profitType"
#define XN_MYINFO_MYPROFIT_PROFITS_AMT @"amt"

@interface XNMIMyProfitMode : NSObject

@property (nonatomic, strong) NSString * minTime;
@property (nonatomic, strong) NSString * dayProfit;
@property (nonatomic, strong) NSString * sumProfit;
@property (nonatomic, strong) NSString * totalProfit;
@property (nonatomic, strong) NSArray  * profitsArray;

+ (instancetype )initMyProfitWithObject:(NSDictionary *)params;
@end
