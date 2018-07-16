//
//  CustomerChatManager.h
//  FinancialManager
//
//  Created by xnkj on 09/09/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerChatManager : NSObject

+ (instancetype)defaultCustomerService;

- (void)chat;
@end
