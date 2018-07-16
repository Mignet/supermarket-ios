//
//  XNCSMyCustomerListMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/20.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_CS_MYCUSTOMERLIST_DATA       @"data"
#define XN_CS_MYCUSTOMERLIST_PAGEINDEX  @"pageIndex"
#define XN_CS_MYCUSTOMERLIST_PAGESIZE   @"pageSize"
#define XN_CS_MYCUSTOMERLIST_PAGECOUNT  @"pageCount"
#define XN_CS_MYCUSTOMERLIST_TOTALCOUNT @"totalCount"
#define XN_CS_MYCUSTOMERLIST_DATA       @"datas"

@interface XNCSMyCustomerListMode : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSString * totalCount;
@property (nonatomic, strong) NSArray  * dataArray;

+ (instancetype )initMyCustomerListWithObject:(NSDictionary *)params;


@end
