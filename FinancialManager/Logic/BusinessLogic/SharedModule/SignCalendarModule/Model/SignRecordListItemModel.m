//
//  SignRecordListItemModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignRecordListItemModel.h"

@implementation SignRecordListItemModel

+ (instancetype)signRecordListItemModelWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        SignRecordListItemModel *pd = [[SignRecordListItemModel alloc] init];
        
        pd.redpacketId = [params objectForKey:Sign_Record_List_Item_Model_redpacketId];
        pd.rownum = [params objectForKey:Sign_Record_List_Item_Model_rownum];
        pd.signTime = [params objectForKey:Sign_Record_List_Item_Model_signTime];
        pd.times = [params objectForKey:Sign_Record_List_Item_Model_times];
        pd.timesAmount = [params objectForKey:Sign_Record_List_Item_Model_timesAmount];
        pd.timesType = [params objectForKey:Sign_Record_List_Item_Model_timesType];
        pd.signAmount = [params objectForKey:Sign_Record_List_Item_Model_signAmount];
               
        return pd;
    }
    return nil;
}

@end
