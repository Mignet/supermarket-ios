//
//  XNBundThirdPageMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 8/16/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_BUND_THIRD_PAGE_MODE_DATA @"data"
#define XN_BUND_THIRD_PAGE_MODE_INTEGRATIONMODE @"integrationMode"
#define XN_BUND_THIRD_PAGE_MODE_PRODUCT_CODE @"productCode"
#define XN_BUND_THIRD_PAGE_MODE_REFERRAL @"referral"
#define XN_BUND_THIRD_PAGE_MODE_REQUEST_URL @"requestUrl"

@interface XNBundThirdPageMode : NSObject

@property (nonatomic, strong) NSString *data; //加密数据
@property (nonatomic, strong) NSString *integrationMode; //加密方式
@property (nonatomic, strong) NSString *productCode; //基金代码
@property (nonatomic, strong) NSString *referral; //合作伙伴
@property (nonatomic, strong) NSString *requestUrl; //请求地址

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
