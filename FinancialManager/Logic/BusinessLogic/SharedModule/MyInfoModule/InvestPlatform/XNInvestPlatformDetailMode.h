//
//  XNInvestPlatformDetailMode.h
//  FinancialManager
//
//  Created by xnkj on 29/06/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_INVESTAMT @"investingAmt"
#define XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_INVESTPROFIT @"investingProfit"
#define XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_PLATFORMLOGO @"platformLogo"
#define XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_ORGACCOUNT @"orgAccount"
#define XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_ORGKEY @"orgKey"
#define XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_ORGNUMBER @"orgNumber"
#define XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_ORGUSERCENTERURL @"orgUsercenterUrl"
#define XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_REQUESTFORM @"requestFrom"
#define XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_SIGN @"sign"
#define XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_TIMESTAMP @"timestamp"
#define XN_MYINFO_INVEST_PLATFORM_INVESTPLATFORM_NAME @"orgName"

@interface XNInvestPlatformDetailMode : NSObject

@property (nonatomic, strong) NSString * investingAmt;
@property (nonatomic, strong) NSString * investingProfit;
@property (nonatomic, strong) NSString * platformLogo;
@property (nonatomic, strong) NSString * platformName;
@property (nonatomic, strong) NSString * orgAccount;
@property (nonatomic, strong) NSString * orgKey;
@property (nonatomic, strong) NSString * orgNumber;
@property (nonatomic, strong) NSString * orgUsercenterUrl;
@property (nonatomic, strong) NSString * requestFrom;
@property (nonatomic, strong) NSString * sign;
@property (nonatomic, strong) NSString * timestamp;

+ (instancetype)initInvestPlatformDetailWithParams:(NSDictionary *)params;
@end
