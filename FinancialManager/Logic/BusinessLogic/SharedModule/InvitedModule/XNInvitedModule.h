//
//  XNInvitedModule.h
//  FinancialManager
//
//  Created by xnkj on 15/12/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

@class XNInvitedCustomerMode,XNInvitedContactMode,XNInviedListStaticsMode,XNInvitedListMode,XNInvitedCountMode;
@interface XNInvitedModule : AppModuleBase

@property (nonatomic, strong) XNInvitedCustomerMode * invitedCustomerMode;
@property (nonatomic, strong) XNInvitedContactMode  * invitedContactMode;
@property (nonatomic, strong) XNInviedListStaticsMode * invitedStaticsMode;
@property (nonatomic, strong) XNInvitedListMode     * invitedListMode;
@property (nonatomic, strong) NSDictionary          * invitedHomeInfoMode;

@property (nonatomic, strong) NSString     *regiteredCfgCount;//理财师邀请人数
@property (nonatomic, strong) XNInvitedListMode * invitedCfgListMode;
@property (nonatomic, strong) XNInvitedListMode * invitedCustomerListMode;
@property (nonatomic, strong) XNInviedListStaticsMode * invitedCustomerStatisticMode;
@property (nonatomic, strong) XNInvitedCountMode *invitedCountMode;

+ (instancetype)defaultModule;

/**
 * 邀请客户
 * */
- (void)xnInvitedCustomerRequest;

/**
 * 通讯录邀请
 * 
 * params type 邀请类型（1表示邀请客户，2表示邀请理财师)
 * params mobiles 手机号码串，每个手机号之间用，分割
 * params names 通讯录中用户名，用逗号分割 
 *
 **/
- (void)xnInvitedContactListRequestWithMobile:(NSArray *)mobiles userNames:(NSArray *)userNames type:(NSString *)type;

/**
 * 通知后端通讯录邀请的状态
 * 
 * params mobiles 被邀请成功的手机号码序列
 *
 **/
- (void)xnNotificationContactInvitedStatusForMobiles:(NSArray *)mobiles;

/**
 * 推荐理财师列表-累计
 **/
- (void)xnInvitedTotalFM;

/**
 * 推荐理财师列表
 *
 * params name 姓名或者手机号码
 * params pageIndex 第几页
 * params pageSize 页大小
 *
 **/
- (void)xnInvitedListForName:(NSString *)name pageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;

/**
 * 推荐理财师首页
 **/
- (void)xnInvitedHomeInfo;

/**
 *  邀请理财师记录列表
 *  params pageIndex
 *  params pageSize
 **/
- (void)requestCfgInvitedListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;

/**
 * 邀请理财师记录统计
 **/
- (void)requestCfgStatistic;

/**
 * 邀请客户记录统计
 **/
- (void)requestInvistCustomerStatistic;

/**
 * 邀请客户列表
 **/
- (void)requestInvistCustomerListWithPageIndex:(NSString *)pageIndex pageSize:(NSString *)pageSize;

/**
 * 邀请记录-统计数量
 **/
- (void)requestInvitedCount;

@end
