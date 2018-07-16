//
//  XNFMInvitedListItemMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_FM_INVITEDLIST_ITEM_USERNAME @"userName"
#define XN_FM_INVITEDLIST_ITEM_REGISTERDATE @"registerTime"
#define XN_FM_INVITEDLIST_ITEM_CUSTOMPHONE @"mobile"
#define XN_FM_INVITEDLIST_ITEM_INVESTFLAGE @"isInvest"
#define XN_FM_INVITEDLIST_ITEM_HAVEINVITATION @"haveInvitation"

@interface XNInvitedItemMode : NSObject

@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * registerTime;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * isInvest; //是否投资(0未投资 1已投资)
@property (nonatomic, copy) NSString * haveInvitation; //是否发展下级(	0未发展下级 1已发展下级)

+ (instancetype)initInvitedItemWithObject:(NSDictionary *)params;
@end
