//
//  AsyCustomerListModuleObserver.h
//  FinancialManager
//
//  Created by xnkj on 09/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

@class AsyCustomerListModule;
@protocol AsyCustomerListmoduleObserver <NSObject>
@optional

//queue中获取客户列表
- (void)asyCustomerListModuleGetCustomerListDidSuccess:(AsyCustomerListModule *)module;
- (void)asyCustomerListModuleGetCustomerListDidFailed:(AsyCustomerListModule *)module;

//queue中获取理财师列表
- (void)asyCustomerListModuleGetCfgListDidSuccess:(AsyCustomerListModule *)module;
- (void)asyCustomerListModuleGetCfgListDidFailed:(AsyCustomerListModule *)module;
@end
