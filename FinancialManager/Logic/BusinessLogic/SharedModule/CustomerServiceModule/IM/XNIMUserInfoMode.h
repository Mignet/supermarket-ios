//
//  XNIMUserInfoMode.h
//  FinancialManager
//
//  Created by xnkj on 16/1/7.
//  Copyright © 2016年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

//“userId”:” d49b90e6-e023-475e-9271-453012b2b7ef”, //用户ID
//“userName”:” 张猛”, //用户姓名
//“mobile”:”18626019700” //手机号码
//"easemobAcct":"3e5e57fc05d0581d4b2efdd0266623bf1451894",//环信帐号

#define XN_CS_IM_USERINFO_USERID @"userId"
#define XN_CS_IM_USERINFO_USERNAME @"userName"
#define XN_CS_IM_USERINFO_MOBILE @"mobile"
#define XN_CS_IM_USERINFO_USERPIC @"image"
#define XN_CS_IM_USERINFO_EASEMOBACCOUNT @"easemobAcct"

@interface XNIMUserInfoMode : NSObject

@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * userPic;
@property (nonatomic, strong) NSString * easemobAccount;

+ (instancetype )initIMUserInfoWithParams:(NSDictionary *)params;
@end
