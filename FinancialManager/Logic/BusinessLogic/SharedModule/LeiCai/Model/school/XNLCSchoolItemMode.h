//
//  XNLCSchoolItemMode.h
//  FinancialManager
//
//  Created by xnkj on 07/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_LC_SCHOOL_ITEM_CREATE_TIME @"createTime"
#define XN_LC_SCHOOL_ITEM_IMG @"img"
#define XN_LC_SCHOOL_ITEM_LABEL @"label"
#define XN_LC_SCHOOL_ITEM_LINKURL @"linkUrl"
#define XN_LC_SCHOOL_ITEML_TITLE @"title"
#define XN_LC_SCHOOL_ITEM_ID @"id"
#define XN_LC_SCHOOL_SUMMARY @"summary"
#define XN_LC_AGENT_ACTIVITY_SHAREDESC @"shareDesc"
#define XN_LC_AGENT_ACTIVITY_SHAREICON @"shareIcon"
#define XN_LC_AGENT_ACTIVITY_SHARELINK @"shareLink"
#define XN_LC_AGENT_ACTIVITY_SHAREDTITLE @"shareTitle"

@interface XNLCSchoolItemMode : NSObject

@property (nonatomic, strong) NSString * schoolId;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, strong) NSString * img;
@property (nonatomic, strong) NSString * label;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * linkUrl;
@property (nonatomic, strong) NSString * shareDesc;
@property (nonatomic, strong) NSString * shareIcon;
@property (nonatomic, strong) NSString * shareLink;
@property (nonatomic, strong) NSString * shareTitle;

+ (instancetype)initLCSchoolItemWithParams:(NSDictionary *)parmas;
@end
