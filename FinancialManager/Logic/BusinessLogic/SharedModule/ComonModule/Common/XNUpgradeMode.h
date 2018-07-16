//
//  XNUpgradeMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/30.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_COMMON_UPGRADE_DOWNLOADURL @"downloadUrl"
#define XN_COMMON_UPGRADE_ISSUETIME @"issueTime"
#define XN_COMMON_UPGRADE_MINVERSION @"minVersion"
#define XN_COMMON_UPGRADE_NAME @"name"
#define XN_COMMON_UPGRADE_OPENREG @"openReg"
#define XN_COMMON_UPGRADE_REGHINTS @"regHints"
#define XN_COMMON_UPGRADE_UPDATEHINTS @"updateHints"
#define XN_COMMON_UPGRADE_UPGRADE @"upgrade"
#define XN_COMMON_UPGRADE_VERSION @"version"

@interface XNUpgradeMode : NSObject

@property (nonatomic, strong) NSString * downloadUrl;
@property (nonatomic, strong) NSString * issueTime;
@property (nonatomic, strong) NSString * minVersion;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * openReg;
@property (nonatomic, strong) NSString * regHints;
@property (nonatomic, strong) NSString * updateHints;
@property (nonatomic, strong) NSString * updateTitle;
@property (nonatomic, strong) NSString * updateContent;
@property (nonatomic, strong) NSString * upgradeType;
@property (nonatomic, strong) NSString * version;

+ (instancetype )initUpgradeWithObject:(NSDictionary *)params;
@end
