//
//  XNPlatformUserCenter.h
//  FinancialManager
//
//  Created by ancye.Xie on 9/23/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_ORG_ACCOUNT @"orgAccount"
#define XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_ORG_KEY @"orgKey"
#define XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_ORG_NUMBER @"orgNumber"
#define XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_SIGN @"sign"
#define XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_REQUEST_FROM @"requestFrom"
#define XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_TIMESTAMP @"timestamp"

#define XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_ORG_USER_CENTER_URL @"orgUsercenterUrl"

#define XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_ORG_PRODUCT_URL  @"orgProductUrl"
#define XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_THIRD  @"thirdProductId"
#define XN_PLATFORM_USER_CENTER_OR_PRODUCT_MODE_TXID  @"txId"

@interface XNPlatformUserCenterOrProductMode : NSObject

//公告部分
@property (nonatomic, copy) NSString *orgAccount; //第三方机构用户账号
@property (nonatomic, copy) NSString *orgKey; //机构公钥
@property (nonatomic, copy) NSString *orgNumber; //机构编码
@property (nonatomic, copy) NSString *sign; //签名
@property (nonatomic, copy) NSString *requestFrom; //请求来源(web=PC端;wap=移动端)
@property (nonatomic, copy) NSString *timestamp; //时间戳

//用户中心
@property (nonatomic, copy) NSString *orgUsercenterUrl; //用户中心跳转地址

//产品
@property (nonatomic, copy) NSString *orgProductUrl; //机构产品跳转地址
@property (nonatomic, copy) NSString *thirdProductId; //第三方机构产品id
@property (nonatomic, copy) NSString *txId; //交易流水号

+ (instancetype )initWithParams:(NSDictionary *)params;

@end
