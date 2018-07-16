//
//  XNLCActivityModel.h
//  FinancialManager
//
//  Created by xnkj on 04/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNLCActivityModel : NSObject

@property (nonatomic, strong) NSString * activityCode;
@property (nonatomic, strong) NSString * activityDesc;
@property (nonatomic, strong) NSString * activityImg;
@property (nonatomic, strong) NSString * activityName;
@property (nonatomic, strong) NSString * activityPlatform;
@property (nonatomic, strong) NSString * activityStatus;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * subTitle;
@property (nonatomic, strong) NSString * startDate;
@property (nonatomic, strong) NSString * endDate;

+ (instancetype)initLCActivityModeWithParams:(NSDictionary *)params;
@end
