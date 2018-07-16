//
//  XNFMProductCategoryListMode.h
//  FinancialManager
//
//  Created by xnkj on 5/24/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_CS_MYCUSTOMERLIST_PAGEINDEX  @"pageIndex"
#define XN_CS_MYCUSTOMERLIST_PAGESIZE   @"pageSize"
#define XN_CS_MYCUSTOMERLIST_PAGECOUNT  @"pageCount"
#define XN_CS_MYCUSTOMERLIST_TOTALCOUNT @"totalCount"
#define XN_CS_MYCUSTOMERLIST_DATA       @"datas"

@interface XNFMProductCategoryListMode : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSString * totalCount;
@property (nonatomic, strong) NSArray  * dataArray;

+ (instancetype)initProductCategoryListWithParams:(NSDictionary *)params;
@end
