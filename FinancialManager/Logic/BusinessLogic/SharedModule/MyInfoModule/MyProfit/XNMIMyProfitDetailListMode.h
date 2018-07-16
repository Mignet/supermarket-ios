//
//  XNMIMyProfitListMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MYINFO_MYPROFIT_DETAIL_LIST_PAGEINDEX  @"pageIndex"
#define XN_MYINFO_MYPROFIT_DETAIL_LIST_PAGESIZE   @"pageSize"
#define XN_MYINFO_MYPROFIT_DETAIL_LIST_PAGECOUNT  @"pageCount"
#define XN_MYINFO_MYPROFIT_DETAIL_LIST_TOTALCOUNT @"totalCount"
#define XN_MYINFO_MYPROFIT_DETAIL_LIST_DATA       @"datas"
#define XN_MYINFO_MYPROFIT_DETAIL_LIST_DATA_PROFITS_TYPE @"profitName"
#define XN_MYINFO_MYPROFIT_DETAIL_LIST_DATA_TIME @"date"
#define XN_MYINFO_MYPROFIT_DETAIL_LIST_DATA_AMT @"amt"
#define XN_MYINFO_MYPROFIT_DETAIL_LIST_DATA_CONTENT @"remark"

@interface XNMIMyProfitDetailListMode : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSString * totalCount;
@property (nonatomic, strong) NSArray  * dataArray;

+ (instancetype )initMyProfitDetailListWithObject:(NSDictionary *)params;
@end
