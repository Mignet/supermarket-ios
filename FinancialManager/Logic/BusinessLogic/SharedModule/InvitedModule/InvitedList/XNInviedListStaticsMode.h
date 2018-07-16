//
//  XNFMInviedListStaticsMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_FMINVITEDLIST_STATISTIC_RCPERSONS  @"investedCount"
#define XN_FMINVITEDLIST_STATISTIC_REGPERSONS @"regiteredCount"

@interface XNInviedListStaticsMode : NSObject

@property (nonatomic, strong) NSString * InvitedPersons;
@property (nonatomic, strong) NSString * RegisterPersons;

+ (instancetype )initInvitedListStaticsWithObject:(NSDictionary *)params;
@end
