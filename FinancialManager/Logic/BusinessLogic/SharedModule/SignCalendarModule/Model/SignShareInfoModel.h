//
//  SignShareInfoModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Sign_Share_Info_Model_shareDesc @"shareDesc"

@interface SignShareInfoModel : NSObject

@property (nonatomic, copy) NSString *shareDesc;

+ (instancetype)signShareInfoModelWithParams:(NSDictionary *)params;

@end
