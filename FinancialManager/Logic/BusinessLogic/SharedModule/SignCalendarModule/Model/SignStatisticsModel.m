//
//  SignStatisticsModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignStatisticsModel.h"

@implementation SignStatisticsModel

+ (instancetype)signStatisticsModelWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        SignStatisticsModel * pd = [[SignStatisticsModel alloc] init];
        
        pd.dissatisfyDescription = [params objectForKey:Sign_Statistics_Model_dissatisfyDescription];
        pd.firstSignTime = [params objectForKey:Sign_Statistics_Model_firstSignTime];
        pd.leftBouns = [params objectForKey:Sign_Statistics_Model_leftBouns];
        pd.totalBouns = [params objectForKey:Sign_Statistics_Model_totalBouns];
        pd.transferBouns = [params objectForKey:Sign_Statistics_Model_transferBouns];
        pd.userName = [params objectForKey:Sign_Statistics_Model_userName];
        pd.transferedBouns = [params objectForKey:Sign_Statistics_Model_transferedBouns];
        
        return pd;
    }
    
    return nil;
}

@end
