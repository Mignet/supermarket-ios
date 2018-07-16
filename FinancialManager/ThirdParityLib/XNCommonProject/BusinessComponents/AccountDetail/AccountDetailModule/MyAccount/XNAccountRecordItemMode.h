//
//  XNAccountRecordItemMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*	"typeName": “【佣金收益】”, //类别
 “time”:”2015-05-06 23:15”,//发生时间
 “amt”:”+828.88”,//金额(单位元)
 “content”:”2015年9月初级理财师津贴到账”//内容
*/


#define XN_ACCOUNT_RECORD_ITEM_TYPENAME @"typeName"
#define XN_ACCOUNT_RECORD_ITEM_TIME @"transDate"
#define XN_ACCOUNT_RECORD_ITEM_AMOUNT @"transAmount"
#define XN_ACCOUNT_RECORD_ITEM_FEE @"fee"
#define XN_ACCOUNT_RECORD_ITEM_CONTENT @"remark"

@interface XNAccountRecordItemMode : NSObject

@property (nonatomic, strong) NSString * typeName;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * profitFee;
@property (nonatomic, strong) NSString * content;

+ (instancetype )initAccountRecordItemWithObject:(NSDictionary *)params;
@end
