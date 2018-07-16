//
//  MyInfoModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

@class XNRelatedModule;
@protocol XNRelatedModuleObserver <NSObject>
@optional

//意见反馈
- (void)XNMyInfoModuleFeedBackDidReceive:(XNRelatedModule *)module;
- (void)XNMyInfoModuleFeedBackDidFailed:(XNRelatedModule *)module;

//查询消息免打扰设置信息消息
- (void)XNMyInfoModuleQueryMsgNoDisturbDidReceive:(XNRelatedModule *)module;
- (void)XNMyInfoModuleQueryMsgNoDisturbDidFailed:(XNRelatedModule *)module;

//消息免打扰设置
- (void)XNMyInfoModuleSetMsgNoDisturbDidReceive:(XNRelatedModule *)module;
- (void)XNMyInfoModuleSetMsgNoDisturbDidFailed:(XNRelatedModule *)module;


@end
