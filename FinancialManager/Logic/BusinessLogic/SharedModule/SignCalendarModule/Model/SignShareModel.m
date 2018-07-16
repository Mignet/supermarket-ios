//
//  SignShareModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/11/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SignShareModel.h"
#import "RedPacketInfoMode.h"

@implementation SignShareModel

+ (instancetype)signShareModelWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        SignShareModel *pd = [[SignShareModel alloc] init];
        
        pd.bouns = [params objectForKey:Sign_Share_Model_bouns];
        pd.prizeType = [params objectForKey:Sign_Share_Model_prizeType];
        pd.redpacketResponse = [RedPacketInfoMode initRedPacketInfoWithParams:[params objectForKey:Sign_Share_Model_redpacketResponse]];
        
        return pd;
    }
    return nil;
}

@end
