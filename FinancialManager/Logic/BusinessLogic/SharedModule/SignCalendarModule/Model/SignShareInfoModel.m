//
//  SignShareInfoModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignShareInfoModel.h"

@implementation SignShareInfoModel

+ (instancetype)signShareInfoModelWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        SignShareInfoModel *pd = [[SignShareInfoModel alloc] init];
        
        pd.shareDesc = [params objectForKey:Sign_Share_Info_Model_shareDesc];
        
        return pd;
    }
    return nil;
}


@end
