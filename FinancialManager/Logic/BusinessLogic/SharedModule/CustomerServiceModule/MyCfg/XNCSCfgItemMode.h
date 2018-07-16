//
//  XNCSCfgItemMode.h
//  FinancialManager
//
//  Created by xnkj on 24/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_CS_CFG_HEADIMAGE @"headImage"
#define XN_CS_CFG_MOBILE @"mobile"
#define XN_CS_CFG_REGISTTIME @"registTime"
#define XN_CS_CFG_TEAMMEMBERCOUNT @"teamMemberCount"
#define XN_CS_CFG_USERNAME @"userName"
#define XN_CS_CFG_USERID @"userId"

@interface XNCSCfgItemMode : NSObject

@property (nonatomic, strong) NSString * headImage;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * registTime;
@property (nonatomic, strong) NSString * teamMemberCount;
@property (nonatomic, strong) NSString * userName;

+ (instancetype)initCSCfgItemWithParams:(NSDictionary *)parmas;
@end
