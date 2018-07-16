//
//  XNLCBrandPromotionMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 6/28/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNLCBrandPromotionMode.h"

@implementation XNLCBrandPromotionMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNLCBrandPromotionMode *pd = [[XNLCBrandPromotionMode alloc] init];
        
        pd.qrcode = [params objectForKey:XNLC_BRAND_PROMOTION_QRCODE];
        pd.hotContent = [params objectForKey:XNLC_BRAND_PROMOTION_HOT_CONTENT];
        pd.hotPosterList = [params objectForKey:XNLC_BRAND_PROMOTION_HOT_POSTER_LIST];
        pd.recomContent = [params objectForKey:XNLC_BRAND_PROMOTION_RECOMMENT_CONTENT];
        pd.recommenList = [params objectForKey:XNLC_BRAND_PROMOTION_RECOMMENT_LIST];
        return pd;
    }
    return nil;

}

@end
