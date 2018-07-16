//
//  XNCommonMsgListMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/15.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_FM_INVITEDLIST_PAGEINDEX  @"pageIndex"
#define XN_FM_INVITEDLIST_PAGESIZE   @"pageSize"
#define XN_FM_INVITEDLIST_PAGECOUNT  @"pageCount"
#define XN_FM_INVITEDLIST_TOTALCOUNT @"totalCount"
#define XN_FM_INVITEDLIST_DATA       @"datas"


@interface XNCommonMsgListMode : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSString * totalCount;
@property (nonatomic, strong) NSArray  * dataArray;

+ (instancetype )initCommonMsgListWithObject:(NSDictionary *)params;

@end
