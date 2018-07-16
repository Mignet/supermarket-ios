//
//  XNLCSaleGoodNewsListMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 7/26/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XNLC_SALE_GOOD_NEWS_LIST_MODE_PAGEINDEX @"pageIndex"
#define XNLC_SALE_GOOD_NEWS_LIST_MODE_PAGESIZE @"pageSize"
#define XNLC_SALE_GOOD_NEWS_LIST_MODE_PAGECOUNT @"pageCount"
#define XNLC_SALE_GOOD_NEWS_LIST_MODE_TOTALCOUNT @"totalCount"
#define XNLC_SALE_GOOD_NEWS_LIST_MODE_GOODTRANSLIST @"datas"

@interface XNLCSaleGoodNewsListMode : NSObject

@property (nonatomic, copy) NSString *pageIndex;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *pageCount;
@property (nonatomic, copy) NSString *totalCount;
@property (nonatomic, strong) NSMutableArray *datas;

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
