//
//  XNCSNewCustomerModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_CS_MYCUSTOMERLIST_DATA       @"data"
#define XN_CS_MYCUSTOMERLIST_PAGEINDEX  @"pageIndex"
#define XN_CS_MYCUSTOMERLIST_PAGESIZE   @"pageSize"
#define XN_CS_MYCUSTOMERLIST_PAGECOUNT  @"pageCount"
#define XN_CS_MYCUSTOMERLIST_TOTALCOUNT @"totalCount"
#define XN_CS_MYCUSTOMERLIST_DATAS      @"datas"

@interface XNCSNewCustomerModel : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSString * totalCount;
@property (nonatomic, strong) NSArray  * dataArray;

+ (instancetype )initNewMyCustomerListWithObject:(NSDictionary *)params;



@end
