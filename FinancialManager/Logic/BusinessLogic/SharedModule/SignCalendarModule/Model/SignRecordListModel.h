//
//  SignRecordListModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Sign_Record_List_Model_pageIndex  @"pageIndex"
#define Sign_Record_List_Model_pageSize   @"pageSize"
#define Sign_Record_List_Model_pageCount  @"pageCount"
#define Sign_Record_List_Model_totalCount @"totalCount"
#define Sign_Record_List_Model_datas      @"datas"

@interface SignRecordListModel : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSString * totalCount;

@property (nonatomic, strong) NSArray  * recordArr;


+ (instancetype)signRecordListModelWithParams:(NSDictionary *)params;

@end
