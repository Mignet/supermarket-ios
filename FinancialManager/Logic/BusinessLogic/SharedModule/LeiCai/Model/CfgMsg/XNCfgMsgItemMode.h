//
//  XNCfgMsgMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 10/10/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_CFG_MSG_MODE_CRT_TIME @"crtTime"
#define XN_CFG_MSG_MODE_IMG @"img"
#define XN_CFG_MSG_MODE_ICON @"shareIcon"
#define XN_CFG_MSG_MODE_LINK_URL @"linkUrl"
#define XN_CFG_MSG_MODE_NAME @"name"
#define XN_CFG_MSG_MODE_NEWS_ID @"newsId"
#define XN_CFG_MSG_MODE_SUMMARY @"summary"
#define XN_CFG_MSG_MODE_TITLE @"title"
#define XN_CFG_MSG_MODE_TYPENAME @"typeName"

@interface XNCfgMsgItemMode : NSObject

@property (nonatomic, copy) NSString * crtTime; //开始有效时间
@property (nonatomic, copy) NSString * img;
@property (nonatomic, copy) NSString * sharedIcon; //图片地址
@property (nonatomic, copy) NSString * sharedLink; //详情地址

@property (nonatomic, copy) NSString * name; //名称
@property (nonatomic, assign) NSInteger newsId; //资讯Id
@property (nonatomic, copy) NSString * sharedDesc; //简介
@property (nonatomic, copy) NSString * sharedTitle; //标题
@property (nonatomic, strong) NSString * typeName;//标签

+ (instancetype )initWithObject:(NSDictionary *)params;

@end
