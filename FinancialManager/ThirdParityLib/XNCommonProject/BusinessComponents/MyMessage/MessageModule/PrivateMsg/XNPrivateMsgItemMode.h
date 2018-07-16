//
//  XNCommonMsgItemMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MESSAGE_PRIVATE_APP_TYPE @"appType"
#define XN_MESSAGE_PRIVATE_CONTENT  @"content"
#define XN_MESSAGE_PRIVATE_CREATE_TIME @"crtTime"
#define XN_MESSAGE_PRIVATE_MSG_ID @"id"
#define XN_MESSAGE_PRIVATE_MODIFY_TIME @"modifyTime"
#define XN_MESSAGE_PRIVATE_ISREAD @"read"
#define XN_MESSAGE_PRIVATE_START_TIME @"startTime"
#define XN_MESSAGE_PRIVATE_STATUS @"status"
#define XN_MESSAGE_PRIVATE_USER_NUMBER @"userNumber"

@interface XNPrivateMsgItemMode : NSObject

@property (nonatomic, strong) NSString *appType; //端口（理财师，投资人）
@property (nonatomic, strong) NSString *content; //消息内容
@property (nonatomic, strong) NSString *createTime; //创建时间
@property (nonatomic, strong) NSString *msgId; //消息ID
@property (nonatomic, strong) NSString *startTime; //生效时间(前端显示该时间)
@property (nonatomic, assign) BOOL       isRead; //是否已读 1已读,0未读
@property (nonatomic, strong) NSString *modifyTime; //更新时间
@property (nonatomic, strong) NSString *status; //状态
@property (nonatomic, strong) NSString *userNumber; //用户ID

+ (instancetype)initPrivateMsgWithObject:(NSDictionary *)params;
@end
