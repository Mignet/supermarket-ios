//
//  XNAccountModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

@class XNAccountModule;
@protocol XNAccountModuleObserver<NSObject>
@optional

//我的账户信息
- (void)XNAccountModuleMyAccountInfoDidReceive:(XNAccountModule *)module;
- (void)XNAccountModuleMyAccountInfoDidFailed:(XNAccountModule *)module;

//我的账户详情类型
- (void)XNAccountModuleMyAccountDetailTypeDidReceive:(XNAccountModule *)module;
- (void)XNAccountModuleMyAccountDetailTypeDidFailed:(XNAccountModule *)module;

//账户的明细
- (void)XNAccountModuleMyAccountDetailListDidReveive:(XNAccountModule *)module;
- (void)XNAccountModuleMyAccountDetailListDidFailed:(XNAccountModule *)module;
@end
