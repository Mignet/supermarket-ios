//
//  MIAccountCenterMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 6/22/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MI_MYINFO_ACCOUNT_CENTER_MODE_AUTHENNAME @"authenName"
#define MI_MYINFO_ACCOUNT_CENTER_MODE_BANKCARD @"bankCard"
#define MI_MYINFO_ACCOUNT_CENTER_MODE_HEADIMAGE @"headImage"
#define MI_MYINFO_ACCOUNT_CENTER_MODE_MOBILE @"mobile"

@interface MIAccountCenterMode : NSObject

@property (nonatomic, copy) NSString *authenName; //姓名
@property (nonatomic, copy) NSString * bankCard; //	银行卡
@property (nonatomic, copy) NSString * headImage; //头像
@property (nonatomic, copy) NSString * mobile; //手机号

+ (instancetype )initWithObject:(NSDictionary *)params;

@end
