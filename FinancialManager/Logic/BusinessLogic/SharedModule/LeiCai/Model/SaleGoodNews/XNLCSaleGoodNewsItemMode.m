//
//  XNLCSaleGoodNewsItemMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/26/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNLCSaleGoodNewsItemMode.h"

@implementation XNLCSaleGoodNewsItemMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNLCSaleGoodNewsItemMode *pd = [[XNLCSaleGoodNewsItemMode alloc] init];
        
        pd.amount = [params objectForKey:XNLC_SALE_GOOD_NEWS_ITEM_MODE_AMOUNT];
        pd.billId = [params objectForKey:XNLC_SALE_GOOD_NEWS_ITEM_MODE_BILLID];
        pd.investTime = [params objectForKey:XNLC_SALE_GOOD_NEWS_ITEM_MODE_INVESTTIME];
        pd.userName = [params objectForKey:XNLC_SALE_GOOD_NEWS_ITEM_MODE_USERNAME];
  
        return pd;
    }
    return nil;
}

@end
