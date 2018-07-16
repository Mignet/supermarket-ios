//
//  XNBundSelectTypeMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/18/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_BUND_SELECT_TYPE_MODE_DELSTATUS @"delStatus"
#define XN_BUND_SELECT_TYPE_MODE_FUND_TYPE @"fundType"
#define XN_BUND_SELECT_TYPE_MODE_FUND_TYPE_KEY @"fundTypeKey"
#define XN_BUND_SELECT_TYPE_MODE_FUND_TYPE_NAME @"fundTypeName"
#define XN_BUND_SELECT_TYPE_MODE_FUND_TYPE_VALUE @"fundTypeValue"
#define XN_BUND_SELECT_TYPE_MODE_ID @"id"
#define XN_BUND_SELECT_TYPE_MODE_ORGNUMBER @"orgNumber"

@interface XNBundSelectTypeMode : NSObject

@property (nonatomic, strong) NSNumber *delStatus; //删除标识
@property (nonatomic, strong) NSString *fundType; //基金类型代码
@property (nonatomic, strong) NSString *fundTypeKey; //基金类型键
@property (nonatomic, strong) NSString *fundTypeName; //基金类型名称
@property (nonatomic, strong) NSString *fundTypeValue; //基金类型值
@property (nonatomic, strong) NSNumber *bId; //主键
@property (nonatomic, strong) NSString *orgNumber; //基金机构编码

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
