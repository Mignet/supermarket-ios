//
//  XNRemindPopMode.h
//  FinancialManager
//
//  Created by xnkj on 08/05/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNRemindPopMode : NSObject

@property (nonatomic, strong) NSString * cfpLevelTitle;
@property (nonatomic, strong) NSString * cfpLevelContent;
@property (nonatomic, strong) NSString * cfpLevelDetail;
@property (nonatomic, strong) NSString * systemTime;

+ (instancetype)initRemindPopWithParams:(NSDictionary *)params;
@end
