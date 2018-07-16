//
//  XNCommonMsgItemMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MESSAGE_COMMON_APP_TYPE @"appType"
#define XN_MESSAGE_COMMON_CREATETIME @"crtTime"
#define XN_MESSAGE_COMMON_MSG_ID  @"id"
#define XN_MESSAGE_COMMON_LINK    @"link"
#define XN_MESSAGE_COMMON_CONTENT  @"message"
#define XN_MESSAGE_COMMON_MODIFYTIME @"modifyTime"
#define XN_MESSAGE_COMMON_READ    @"read"
#define XN_MESSAGE_COMMON_STARTTIME @"startTime"
#define XN_MESSAGE_COMMON_STATUS @"status"

@interface XNCommonMsgItemMode : NSObject

@property (nonatomic, strong) NSString *appType; //端口（理财师，投资人）
@property (nonatomic, strong) NSString * createTime; //创建时间
@property (nonatomic, strong) NSString * msgId; //公告编码
@property (nonatomic, strong) NSString * link; //链接
@property (nonatomic, strong) NSString * content; //内容
@property (nonatomic, strong) NSString *modifyTime; //更新时间
@property (nonatomic, assign) BOOL       isRead;
@property (nonatomic, strong) NSString *startTime; //生效时间，前端显示该时间
@property (nonatomic, strong) NSString *status; //状态

+ (instancetype)initCommonMsgWithObject:(NSDictionary *)params;
@end
