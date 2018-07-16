//
//  SignRecordListModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignRecordListModel.h"
#import "SignRecordListItemModel.h"

@implementation SignRecordListModel

+ (instancetype)signRecordListModelWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        SignRecordListModel *pd = [[SignRecordListModel alloc] init];
        
        pd.pageIndex = [params objectForKey:Sign_Record_List_Model_pageIndex];
        pd.pageSize = [params objectForKey:Sign_Record_List_Model_pageSize];
        pd.pageCount = [params objectForKey:Sign_Record_List_Model_pageCount];
        pd.totalCount = [params objectForKey:Sign_Record_List_Model_totalCount];
        
        
        SignRecordListItemModel * mode = nil;
        NSMutableArray * recordListArr = [NSMutableArray array];
        NSArray * datas = [params objectForKey:Sign_Record_List_Model_datas];
        for (NSInteger index = 0 ; index < datas.count; index ++ ) {
            
            mode = [SignRecordListItemModel signRecordListItemModelWithParams:[datas objectAtIndex:index]];
            [recordListArr addObject:mode];
        }
        pd.recordArr = recordListArr;
        
        return pd;
    }
    return nil;

}

@end
