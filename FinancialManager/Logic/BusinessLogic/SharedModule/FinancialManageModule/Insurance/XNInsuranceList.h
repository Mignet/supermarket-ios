//
//  XNInsuranceList.h
//  FinancialManager
//
//  Created by xnkj on 13/09/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>


#define XN_BUND_LIST_MODE_PAGEINDEX @"pageIndex"
#define XN_BUND_LIST_MODE_PAGESIZE @"pageSize"
#define XN_BUND_LIST_MODE_PAGECOUNT @"pageCount"
#define XN_BUND_LIST_MODE_TOTALCOUNT @"totalCount"
#define XN_BUND_LIST_MODE_DATAS @"datas"

@interface XNInsuranceList : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSArray * insuranceList;

+ (instancetype)initInsuranceListWithParams:(NSDictionary *)params;
@end
