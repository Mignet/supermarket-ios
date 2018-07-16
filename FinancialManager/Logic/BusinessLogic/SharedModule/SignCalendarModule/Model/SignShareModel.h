//
//  SignShareModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Sign_Share_Model_bouns @"bouns"
#define Sign_Share_Model_prizeType @"prizeType"
#define Sign_Share_Model_redpacketResponse @"redpacketResponse"

@class RedPacketInfoMode;

@interface SignShareModel : NSObject

@property (nonatomic, copy) NSString *bouns;
@property (nonatomic, copy) NSString *prizeType;

@property (nonatomic, strong) RedPacketInfoMode *redpacketResponse;

+ (instancetype)signShareModelWithParams:(NSDictionary *)params;

@end
