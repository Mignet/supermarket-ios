//
//  XNMyAccountDeportRecordListMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_ACCOUNT_MYACCOUNT_RECORD_LIST_DATA       @"data"
#define XN_ACCOUNT_MYACCOUNT_RECORD_LIST_PAGEINDEX  @"pageIndex"
#define XN_ACCOUNT_MYACCOUNT_RECORD_LIST_PAGESIZE   @"pageSize"
#define XN_ACCOUNT_MYACCOUNT_RECORD_LIST_PAGECOUNT  @"pageCount"
#define XN_ACCOUNT_MYACCOUNT_RECORD_LIST_TOTALCOUNT @"totalCount"
#define XN_ACCOUNT_MYACCOUNT_RECORD_LIST_DATA       @"datas"

@interface XNMyAccountDeportRecordListMode : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSString * totalCount;
@property (nonatomic, strong) NSArray  * dataArray;

+ (instancetype )initMyAccountRecordListWithObject:(NSDictionary *)params;
@end
