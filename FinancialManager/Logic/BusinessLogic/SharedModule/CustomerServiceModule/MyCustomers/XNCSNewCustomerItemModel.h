//
//  XNCSNewCustomerItemModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_CS_MYCUSTOMER_ITEM_GRADE @"grade"
#define XN_CS_MYCUSTOMER_HEADIMAGE @"headImage"
#define XN_CS_MYCUSTOMER_RECENTTRANDATE @"recentTranDate"
#define XN_CS_MYCUSTOMER_USERNAME @"userName"
#define XN_CS_MYCUSTOMER_MOBILE @"mobile"
#define XN_CS_MYCUSTOMER_USERID @"userId"
#define XN_CS_REGISTER_TIME @"registTime"

@interface XNCSNewCustomerItemModel : NSObject

@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *headImage;
@property (nonatomic, copy) NSString *recentTranDate;
@property (nonatomic, copy) NSString *registerTime;
@property (nonatomic, copy) NSString *userName;

+ (instancetype )initMyNewCustomerWithObject:(NSDictionary *)params;

@end
