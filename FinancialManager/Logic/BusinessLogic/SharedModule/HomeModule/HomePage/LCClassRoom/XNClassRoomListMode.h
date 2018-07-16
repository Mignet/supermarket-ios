//
//  XNClassRoomListMode.h
//  FinancialManager
//
//  Created by xnkj on 13/09/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_HOME_CLASSROOM_DATAS @"datas"

@class XNGrowthManualCategoryItemMode;
@interface XNClassRoomListMode : NSObject

@property (nonatomic, strong) NSArray * classRoomItemNameList;
@property (nonatomic, strong) NSArray * classRoomUrlItemList;
@property (nonatomic, strong) NSArray * classRoomItemModeList;

+ (instancetype)initClassRoomListWithParams:(NSDictionary *)params;
@end
