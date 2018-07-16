//
//  SignBounsTransferModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/24.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Sign_Bouns_Transfer_Model_transferBouns @"transferBouns"

@interface SignBounsTransferModel : NSObject

// 转账户金额
@property (nonatomic, copy) NSString *transferBouns;

+ (instancetype)signBounsTransferModelWithParams:(NSDictionary *)params;

@end
