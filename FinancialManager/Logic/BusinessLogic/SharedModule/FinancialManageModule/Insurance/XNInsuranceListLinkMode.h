//
//  XNInsuranceListLinkMode.h
//  FinancialManager
//
//  Created by xnkj on 15/09/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_INSURANCE_DETAIL_REQUESTURL @"requestUrl"

@interface XNInsuranceListLinkMode : NSObject

@property (nonatomic, strong) NSString * jumpInsuranceUrl;

+ (instancetype)initInsuranceListLinkWithParams:(NSDictionary *)params;
@end
