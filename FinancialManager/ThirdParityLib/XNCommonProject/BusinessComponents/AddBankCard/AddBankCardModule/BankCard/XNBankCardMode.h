//
//  XNGetBankCardInfoMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/17.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_ACCOUNT_BANKCARD_BANK_CODE @"remark"
#define XN_ACCOUNT_BANKCARD_BANK_HAVEBIND @"haveBind"

@interface XNBankCardMode : NSObject

@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * haveBind;//是否之前绑定过卡- 0表示否，1表示绑定过

+ (instancetype )initBankCardModeWithObject:(NSDictionary *)params;
@end
