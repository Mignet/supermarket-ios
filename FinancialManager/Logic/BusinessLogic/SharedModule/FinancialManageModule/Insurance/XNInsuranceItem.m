//
//  XNInsuranceItem.m
//  FinancialManager
//
//  Created by xnkj on 13/09/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNInsuranceItem.h"

@implementation XNInsuranceItem

+ (instancetype)initInsuranceWithParams:(NSDictionary *)params
{
    if (params) {
        
        XNInsuranceItem * pd = [[XNInsuranceItem alloc]init];
        
        pd.caseCode = [params objectForKey:XN_INSURANCE_ITEM_CASECODE];
        pd.fristCategory = [params objectForKey:XN_INSURANCE_ITEM_FIRSTCATEGORY];
        pd.productName = [params objectForKey:XN_INSURACEN_ITEM_PRODUCTNAME];
        pd.fullDescription = [params objectForKey:XN_INSURANCE_ITEM_PRODUCTDESC];
        pd.price = [NSString stringWithFormat:@"%@",[params objectForKey:XN_INSURANCE_ITEM_PRODUCTPRICE]];
        pd.priceString = [params objectForKey:XN_INSURANCE_ITEM_PRODUCTPRICESTRING];
        pd.productBakimg = [params objectForKey:XN_INSURANCE_ITEM_PRODUCTBAKIMG];
        pd.feeRatio = [NSString stringWithFormat:@"%@",[params objectForKey:XN_INSURANCE_ITEM_FEERATIO]];
        
        return pd;
    }
    return nil;
}
@end
