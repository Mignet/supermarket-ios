//
//  SignBounsTransferModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/24.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignBounsTransferModel.h"

@implementation SignBounsTransferModel

+ (instancetype)signBounsTransferModelWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        SignBounsTransferModel *pd = [[SignBounsTransferModel alloc] init];
        
        pd.transferBouns = [params objectForKey:Sign_Bouns_Transfer_Model_transferBouns];
        
        return pd;
    }
    return nil;
}

@end
