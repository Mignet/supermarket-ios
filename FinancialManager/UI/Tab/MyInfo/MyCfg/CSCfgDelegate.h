//
//  CSCustomerDelegate.h
//  FinancialManager
//
//  Created by xnkj on 6/22/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

@protocol CSCfgDelegate <NSObject>
@optional

- (void)cfgListDidClickMobileContact;
- (void)cfgListDidClickUnInvestedCfg;
- (void)cfgListDidClickCaredCfg;
@end
