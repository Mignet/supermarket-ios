//
//  XNUserIsRegMode.h
//  FinancialManager
//
//  Created by xnkj on 15/12/24.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

//“regFlag”:1 ,// 0未注册(非第三方账号),1未注册(第三方账号) 2已注册
//“regSource”:”钱罐子”,//第三方账号来源
//“regLimit”:true,//注册限制(true限制注册,false可以注册)
//“regLimitMsg”:” 您是理财师专属客户，需由您的理财师推荐您升级”//注册限制提示语

#define XN_USER_ISREG_REGFLAG @"regFlag"
#define XN_USER_ISREG_REGSOURCE @"regSource"
#define XN_USER_ISREG_REGLIMIT @"regLimit"
#define XN_USER_ISREG_REGLIMITMSG @"regLimitMsg"

@interface XNUserIsRegMode : NSObject

@property (nonatomic, strong) NSString * regFlag;
@property (nonatomic, strong) NSString * regSource;
@property (nonatomic, assign) BOOL isRegLimit;
@property (nonatomic, strong) NSString * regLimitMsg;

+ (instancetype)initUserIsRegObjectWithParams:(NSDictionary *)params;
@end
