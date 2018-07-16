//
//  CSCustomerDelegate.h
//  FinancialManager
//
//  Created by xnkj on 6/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

@protocol CSCustomerDelegate <NSObject>
@optional

- (void)customerListDidClickMobileContact;
- (void)customerListDidClickUnInvestedCustomer;
- (void)customerListDidClickCaredCustomer;
@end
