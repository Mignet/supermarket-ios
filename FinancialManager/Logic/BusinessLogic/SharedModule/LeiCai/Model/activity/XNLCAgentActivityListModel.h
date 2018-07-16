//
//  XNLCAgentActivityListModel.h
//  FinancialManager
//
//  Created by xnkj on 07/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNLCAgentActivityListModel : NSObject

@property (nonatomic, strong) NSString * pageIndex;
@property (nonatomic, strong) NSString * pageSize;
@property (nonatomic, strong) NSString * pageCount;
@property (nonatomic, strong) NSString * totalCount;
@property (nonatomic, strong) NSMutableArray * agentActivityArray;

+ (instancetype)initLCAgentActivityListWithParams:(NSDictionary *)params;

@end
