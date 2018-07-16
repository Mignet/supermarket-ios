//
//  ProductRedPacketItemModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/25.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductRedPacketItemModel : NSObject

// 限制金额    number
@property (nonatomic, copy) NSString *amount;

// 金额限制    number    0=不限|1=大于|2=大于等于
@property (nonatomic, copy) NSString *amountLimit;

//    理财师编号    string
@property (nonatomic, copy) NSString *cfplannerId;

//    理财师手机号码    string
@property (nonatomic, copy) NSString *cfplannerMobile;


//    理财师名称    string
@property (nonatomic, copy) NSString *cfplannerName;

//    创建时间    string
@property (nonatomic, copy) NSString *createTime;

//    过期时间    string
@property (nonatomic, copy) NSString *expiresDate;

//    红包记录ID    number
@property (nonatomic, copy) NSString *id;

//    用户投资限制    number    0=不限|1=用户首投|2=平台首投
@property (nonatomic, copy) NSString *investLlimit;

//    红包金额    number
@property (nonatomic, copy) NSString *money;

//    红包名称    string
@property (nonatomic, copy) NSString *name;

//    平台编号    string    platform_limit=1时有效
@property (nonatomic, copy) NSString *platformId;

//    平台限制    boolean    1=限制|0=不限制
@property (nonatomic, copy) NSString *platformLimit;

//    平台名称    string    platform_limit=1时有效
@property (nonatomic, copy) NSString *platformName;

//    产品期限    number    product_limit=1002时有效
@property (nonatomic, copy) NSString *productDeadline;

//    产品编号    string    product_limit=1001时有效
@property (nonatomic, copy) NSString *productId;

//    产品限制    number    1000=不限|1001=限制产品编号|1002=限制产品期限|1003=限制产品类型
@property (nonatomic, copy) NSString *productLimit;

//    产品类型    string    product_limit=1003时有效
@property (nonatomic, copy) NSString *productType;

//    红包明细编号    string
@property (nonatomic, copy) NSString *redpacketDetailId;

//    红包ID    string
@property (nonatomic, copy) NSString *redpacketId;

//    红包描述    string
@property (nonatomic, copy) NSString *remark;

//    规则编号    string
@property (nonatomic, copy) NSString *ruleId;

//    发放编号    string
@property (nonatomic, copy) NSString *sendId;

//    派发红包发送者Id    string
@property (nonatomic, copy) NSString *senderUserId;

//    红包状态    number    1=未派发|2=未使用|3=已使用|4=已过期
@property (nonatomic, copy) NSString *status;

//    红包类型    number    1=投资返现|2=现金红包|3=抵现红包
@property (nonatomic, copy) NSString *type;

//    更新时间    string
@property (nonatomic, copy) NSString *updateTime;

//    用户编号    string
@property (nonatomic, copy) NSString *userId;

//    用户手机号码    string
@property (nonatomic, copy) NSString *userMobile;

// 用户名称    string
@property (nonatomic, copy) NSString *userName;

+ (instancetype)initWithProductRedPacketItemModelParams:(NSDictionary *)params;

@end
