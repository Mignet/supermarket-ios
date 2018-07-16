//
//  XNInsuranceDetailMode.m
//  FinancialManager
//
//  Created by xnkj on 14/09/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNInsuranceDetailMode.h"

@implementation XNInsuranceDetailMode

+ (instancetype)initInsuranceDetailWithParams:(NSDictionary *)params
{
    if (params) {
        
        XNInsuranceDetailMode * pd = [[XNInsuranceDetailMode alloc]init];
        
        NSString * jumpUrl = [[params objectForKey:XN_INSURANCE_DETAIL_REQUESTURL] stringByAppendingString:@"?"];
        
        NSString * queryParams = @"";
        for (NSString * key in params.allKeys) {
            
            if (![key isEqualToString:XN_INSURANCE_DETAIL_REQUESTURL]) {
                
                if ([NSObject isValidateInitString:queryParams]) {
                    
                    queryParams = [NSString stringWithFormat:@"%@&%@=%@",queryParams,key,[params objectForKey:key]];
                }else
                {
                    queryParams = [NSString stringWithFormat:@"%@=%@",key,[params objectForKey:key]];
                }
            }
        }
        jumpUrl = [jumpUrl stringByAppendingString:queryParams];
        
        pd.jumpInsuranceUrl = jumpUrl;
        
        return pd;
    }
    return nil;
}
@end
