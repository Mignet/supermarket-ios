//
//  XNMyAccountTotalDeportMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/22.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*"outTotalAmount": 0, // 累计提现金额
 "outTotalFee": 0, // 累计提现手续费
 "outingAmount": 0, // 提现中金额
 "outingFee": 0 // 提现中手续费
*/

#define XN_ACCOUNT_MYACCOUNT_DEPORT_OUTTOTALAMOUNT @"outTotalAmount"
#define XN_ACCOUNT_MYACCOUNT_DEPORT_OUTTOTALLFEE @"outTotalFee"
#define XN_ACCOUNT_MYACCOUNT_DEPORT_OUTINGAMOUNT @"outingAmount"
#define XN_ACCOUNT_MYACCOUNT_DEPORT_OUTINGFEE @"outingFee"

@interface XNMyAccountTotalDeportMode : NSObject

@property (nonatomic, strong) NSString * outTotalAmount;
@property (nonatomic, strong) NSString * outTotalFee;
@property (nonatomic, strong) NSString * outingAmount;
@property (nonatomic, strong) NSString * outingFee;

+ (instancetype )initTotalDeportWithObject:(NSDictionary *)params;
@end
