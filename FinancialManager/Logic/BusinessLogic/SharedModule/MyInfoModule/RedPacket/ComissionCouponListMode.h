//
//  RedPacketListMode.h
//  FinancialManager
//
//  Created by xnkj on 6/27/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MYINFO_MYPROFIT_ITEM_PAGEINDEX  @"pageIndex"
#define XN_MYINFO_MYPROFIT_ITEM_PAGESIZE   @"pageSize"
#define XN_MYINFO_MYPROFIT_ITEM_PAGECOUNT  @"pageCount"
#define XN_MYINFO_MYPROFIT_ITEM_TOTALCOUNT @"totalCount"
#define XN_MYINFO_MYPROFIT_ITEM_DATA       @"datas"

@interface ComissionCouponListMode : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSString * totalCount;
@property (nonatomic, strong) NSArray  * dataArray;

+ (instancetype )initRedPacketListWithObject:(NSDictionary *)params;

@end
