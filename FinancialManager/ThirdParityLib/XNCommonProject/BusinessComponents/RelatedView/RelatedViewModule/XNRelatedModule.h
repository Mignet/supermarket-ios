//
//  MyInfoModule.h
//  FinancialManager
//
//  Created by xnkj on 15/10/23.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "AppModuleBase.h"

#define XN_MYINFO_MYPROFIT_DETAIL_TYPE_DATA @"datas"

@class XNMsgNoDisturbMode;
@interface XNRelatedModule : AppModuleBase

@property (nonatomic, strong) XNMsgNoDisturbMode *msgNoDisturbMode;

+ (instancetype)defaultModule;

/**
 * 意见反馈
 * params content 内容反馈
 **/
- (void)feedBackContent:(NSString *)content;

/**
 * 查询消息免打扰设置信息消息
 **/
- (void)requestMsgNoDisturb;

/**
 * 消息免打扰设置
 * params platformflag 平台消息免打扰是否开启：0-不开启 1-开启免打扰
 **/
- (void)setMsgNoDisturbWithPlatformFlag:(NSString *)platformflag;

@end
