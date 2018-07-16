//
//  XNInvitedContactMode.h
//  FinancialManager
//
//  Created by xnkj on 15/12/28.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_INVITED_CONTACT_CONTENT @"content"
#define XN_INVIRED_CONTACT_ALLOW_INVITED_CUSTOMERS @"customers"
#define XN_INVITED_CONTACT_ALLOW_INVITED_CUSTOMER_MOBILE @"mobile"
#define XN_INVITED_CONTACT_ALLOW_INVITED_CUSTOMER_NAME @"name"

@interface XNInvitedContactMode : NSObject

@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSArray  * allowedInvitedCustomer;

+ (instancetype )initInvitedContactWithParams:(NSDictionary *)params;
@end
