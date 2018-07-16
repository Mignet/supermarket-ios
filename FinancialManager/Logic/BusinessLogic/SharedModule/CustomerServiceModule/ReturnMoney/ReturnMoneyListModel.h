//
//  ReturnMoneyListModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/19.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_CS_TRADELIST_DATA       @"data"
#define XN_CS_TRADELIST_PAGEINDEX  @"pageIndex"
#define XN_CS_TRADELIST_PAGESIZE   @"pageSize"
#define XN_CS_TRADELIST_PAGECOUNT  @"pageCount"
#define XN_CS_TRADELIST_TOTALCOUNT @"totalCount"
#define XN_CS_TRADELIST_DATA       @"datas"

@interface ReturnMoneyListModel : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSString * totalCount;
@property (nonatomic, strong) NSArray  * dataArray;

+ (instancetype )initReturnMoneyItemWithObject:(NSDictionary *)params;

@end
