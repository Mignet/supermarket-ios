//
//  SignRecordListItemModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Sign_Record_List_Item_Model_redpacketId @"redpacketId"
#define Sign_Record_List_Item_Model_rownum @"rownum"
#define Sign_Record_List_Item_Model_signAmount @"signAmount"
#define Sign_Record_List_Item_Model_signTime @"signTime"
#define Sign_Record_List_Item_Model_times @"times"
#define Sign_Record_List_Item_Model_timesAmount @"timesAmount"
#define Sign_Record_List_Item_Model_timesType @"timesType"

@interface SignRecordListItemModel : NSObject

// redpacketId	红包id 非空有红包	string
@property (nonatomic, copy) NSString *redpacketId;

// rownum	签到序号	number
@property (nonatomic, copy) NSString *rownum;

// signAmount	签到金额	string
@property (nonatomic, copy) NSString *signAmount;

// signTime	签到时间	string
@property (nonatomic, copy) NSString *signTime;

// times	倍数	number
@property (nonatomic, copy) NSString *times;

// timesAmount	翻倍金额	string
@property (nonatomic, copy) NSString *timesAmount;

// timesType	翻倍类型 1分享翻倍，2连续签到翻倍	string
@property (nonatomic, copy) NSString *timesType;


+ (instancetype)signRecordListItemModelWithParams:(NSDictionary *)params;

@end
