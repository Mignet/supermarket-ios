//
//  XNLCPersonalCardMode.h
//  FinancialManager
//
//  Created by ancye.Xie on 6/28/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XNCL_PERSONAL_CARD_MODE_MOBILE @"mobile"
#define XNCL_PERSONAL_CARD_MODE_QRCODE @"qrcode"
#define XNCL_PERSONAL_CARD_MODE_USERNAME @"userName"

@interface XNLCPersonalCardMode : NSObject

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *qrcode; //二维码
@property (nonatomic, copy) NSString *userName;

+ (instancetype)initWithObject:(NSDictionary *)params;

@end
