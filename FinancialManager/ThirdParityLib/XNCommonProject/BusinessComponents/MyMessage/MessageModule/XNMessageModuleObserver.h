//
//  XNMessageModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

@class XNMessageModule;
@protocol XNMessageModuleObserver <NSObject>
@optional

//获取公共消息列表
- (void)XNMessageModuleCommonMsgListDidReceive:(XNMessageModule *)module;
- (void)XNMessageModuleCommonMsgListDidFailed:(XNMessageModule *)module;

//获取私人消息
- (void)XNMessageModulePrivateMsgListDidReceive:(XNMessageModule *)module;
- (void)XNMessageModulePrivateMsgListDidFailed:(XNMessageModule *)module;

//删除私人消息
- (void)XNMessageModulePrivateMsgDeleDidReceive:(XNMessageModule *)module;
- (void)XNMessageModulePrivateMsgDeleDidFailed:(XNMessageModule *)module;

//未读消息统计
- (void)XNMessageModuleUnreadMsgCountDidReceive:(XNMessageModule *)module;
- (void)XNMessageModuleUnreadMsgCountDidFailed:(XNMessageModule *)module;

//获取消息详情
- (void)XNMessageModuleAnnounceMsgDetailDidReceive:(XNMessageModule *)module;
- (void)XNMessageModuleAnnounceMsgDetailDidFailed:(XNMessageModule *)module;

//
- (void)XNMessageModuleReadAllMsgDidReceive:(XNMessageModule *)module;
- (void)XNMessageModuleReadAllMsgDidFailed:(XNMessageModule *)module;
@end
