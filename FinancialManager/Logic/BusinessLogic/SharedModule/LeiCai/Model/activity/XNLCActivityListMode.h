//
//  XNLCActivityListMode.h
//  FinancialManager
//
//  Created by xnkj on 04/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNLCActivityListMode : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSString * totalCount;
@property (nonatomic, strong) NSMutableArray * activityArray;

+ (instancetype)initLCActivityListWithParams:(NSDictionary *)params;
@end
