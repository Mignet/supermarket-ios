//
//  XNFMProfitCaculateMode.m
//  FinancialManager
//
//  Created by xnkj on 1/28/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNFMProfitCaculateMode.h"

@implementation XNFMProfitCaculateMode

+ (instancetype)initProfitCaculateWithParams:(NSDictionary *)params
{
    if (params) {
        
        XNFMProfitCaculateMode * pd = [[XNFMProfitCaculateMode alloc]init];
        
        pd.profitValue = [params objectForKey:XN_FM_PRODUCT_DETAIL_PROFITCACULATE_OTHERPROFIT];
        pd.profitName = [params objectForKey:XN_FM_PRODUCT_DETAIL_PROFITCACULATE_NAME];
        pd.profitType = [params objectForKey:XN_FM_PRODUCT_DETAIL_PROFITCACULATE_PROFITTYPE];
        pd.canEdit    = [[params objectForKey:XN_FM_PRODUCT_DETAIL_PROFITCACULATE_ISEDIT] boolValue];
        
        return pd;
    }
    return nil;
}
@end
