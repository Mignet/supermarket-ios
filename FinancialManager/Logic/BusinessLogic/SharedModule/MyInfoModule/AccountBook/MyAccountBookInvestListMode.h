//
//  MyAccountBookInvestListMode.h
//  FinancialManager
//
//  Created by xnkj on 19/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MYINFO_INVEST_RECORD_LIST_PAGEINDEX  @"pageIndex"
#define XN_MYINFO_INVEST_RECORD_LIST_PAGESIZE   @"pageSize"
#define XN_MYINFO_INVEST_RECORD_LIST_PAGECOUNT  @"pageCount"
#define XN_MYINFO_INVEST_RECORD_LIST_TOTALCOUNT @"totalCount"
#define XN_MYINFO_INVEST_RECORD_LIST_DATA       @"datas"

@interface MyAccountBookInvestListMode : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSString * totalCount;
@property (nonatomic, strong) NSArray  * datas;

+ (instancetype)initAccountBookInvestListWithParams:(NSDictionary *)params;
@end
