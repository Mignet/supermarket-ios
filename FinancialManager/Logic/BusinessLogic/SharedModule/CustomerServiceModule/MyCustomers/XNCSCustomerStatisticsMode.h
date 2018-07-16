//
//  CSCustomerStatisticsMode.h
//  FinancialManager
//
//  Created by xnkj on 1/11/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*“regCustomer”:”100” //注册客户
 “investCustomer”:”12” //投资客户
*/

#define XN_CS_CUSTOMER_REGCUSTOMER @"regCustomer"
#define XN_CS_CUSTOMER_INVESTCUSTOMER @"investCustomer"

@interface XNCSCustomerStatisticsMode : NSObject

@property (nonatomic, strong) NSString * regCustomer;
@property (nonatomic, strong) NSString * investCustomer;

+ (instancetype )initCustomerStaticsWithParams:(NSDictionary *)params;
@end
