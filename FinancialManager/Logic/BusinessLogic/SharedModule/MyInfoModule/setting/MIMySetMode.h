//
//  MIMySetMode.h
//  FinancialManager
//
//  Created by xnkj on 15/11/2.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*  bundBankcard	银行卡绑定状态(true/false)
*/

#define XN_MYINFO_SETTING_BUNBANKCARD @"bundBankcard"
#define XN_MYINFO_ONCEMORE_BINDCARD @"onceMoreBindCard"

@interface MIMySetMode : NSObject

@property (nonatomic, assign) BOOL bundBankCard;
@property (nonatomic, assign) BOOL onceMoreBindCard;//多次解绑卡

+ (instancetype )initMySetWithObject:(NSDictionary *)params;
@end
