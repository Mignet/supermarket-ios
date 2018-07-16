//
//  DoubleElevenMode.m
//  FinancialManager
//
//  Created by xnkj on 24/10/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "DoubleElevenMode.h"

@implementation DoubleElevenMode

+ (instancetype)initDoubleElevenWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        DoubleElevenMode * pd = [[DoubleElevenMode alloc]init];
        
        pd.hasNewDoubleEleven = [[params objectForKey:XN_DOUBLEELEVEN_HASNEWDOUBLEELEVEN] integerValue];
        
        return pd;
    }
    return nil;
}
@end
