//
//  XNMessageModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

@class XNCommonMsgListMode,XNPrivateMsgListMode;
@interface XNMessageModule : AppModuleBase

@property (nonatomic, strong) XNCommonMsgListMode * commonMsgListMode;
@property (nonatomic, strong) XNPrivateMsgListMode * privateMsgListMode;
@property (nonatomic, strong) NSDictionary         * unReadMsgMode;

+ (instancetype)defaultModule;

/**
 * 获取公共消息列表
 * params pageIndex 页码
 * params pageSize  页大小
 * */
- (void)requestCommonMsgListAtPageIndex:(NSString *)pageIndex PageSize:(NSString *)pageSize;

/**
 * 获取私人消息列表
 * params pageIndex 页码
 * params pageSize  页大小
 * */
- (void)requestPrivateMsgListAtPageIndex:(NSString *)pageIndex PageSize:(NSString *)pageSize;

/**
 * 个人消息的删除
 * params msgIds 消息id
 * */
- (void)deletePrivateMsgForMsgId:(NSString *)msgId;

/**
 * 未读消息统计
 * */
- (void)getUnReadMsgCount;

/**
 * 获取公告消息详情
 * params msgId 消息id
 **/
- (void)getMsgDetailWithMsgId:(NSString *)msgId;

/**
 *
 *
 **/
- (void)readAllMsg;

@end
