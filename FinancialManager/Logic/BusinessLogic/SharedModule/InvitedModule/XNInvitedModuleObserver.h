//
//  XNInvitedModuleObserver.h
//  FinancialManager
//
//  Created by xnkj on 15/12/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

@class XNInvitedModule;
@protocol XNInvitedModuleObserver <NSObject>
@optional

//邀请顾客
- (void)xnInvitedModuleInvitedCustomerDidReceiver:(XNInvitedModule *)module;
- (void)xnInvitedModuleInvitedCustomerDidFailed:(XNInvitedModule *)module;

//通讯录邀请
- (void)xnInvitedModuleInvitedContactDidReceiver:(XNInvitedModule *)module;
- (void)xnInvitedModuleInvitedContactDidFailed:(XNInvitedModule *)module;

//通讯录邀请回调
- (void)xnInvitedModuleInvitedContactNotificationDidReceiver:(XNInvitedModule *)module;
- (void)xnInvitedModuleInvitedContactNotificationDidFailed:(XNInvitedModule *)module;

//推荐理财师首页
- (void)xnInvitedModuleInvitedHomePageDidReceiver:(XNInvitedModule *)module;
- (void)xnInvitedModuleInvitedHomePageDidFailed:(XNInvitedModule *)module;

//邀请客户统计
- (void)xnInvitedModuleInvitedCustomerStatisticsDidReceiver:(XNInvitedModule *)module;
- (void)xnInvitedModuleInvitedCustomerStatisticsDidFailed:(XNInvitedModule *)module;

//邀请客户列表
- (void)xnInvitedModuleInvitedCustomerListDidReceiver:(XNInvitedModule *)module;
- (void)xnInvitedModuleInvitedCustomerListDidFailed:(XNInvitedModule *)module;

//理财师统计
- (void)XNInvitedModuleInvitedCfgCountDidReceive:(XNInvitedModule *)module;
- (void)XNInvitedModuleInvitedCfgCountDidFailed:(XNInvitedModule *)module;

//理财师列表
- (void)XNInvitedModuleInvitedCfgListDidReceive:(XNInvitedModule *)module;
- (void)XNInvitedModuleInvitedCfgListDidFailed:(XNInvitedModule *)module;

//邀请记录-统计数量
- (void)XNInvitedModuleInvitedCountDidReceive:(XNInvitedModule *)module;
- (void)XNInvitedModuleInvitedCountDidFailed:(XNInvitedModule *)module;

@end
