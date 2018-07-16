//
//  XNCSMyCustomerItemMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/20.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNCSMyCustomerItemMode.h"
#import "JFZDataBase.h"

@implementation XNCSMyCustomerItemMode

+ (instancetype )initMyCustomerWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNCSMyCustomerItemMode * pd = [[XNCSMyCustomerItemMode alloc] init];
        
       
        pd.customerId = [params objectForKey:XN_CS_MYCUSTOMER_ITEM_CUSTOMERID];
        pd.customerName = [params objectForKey:XN_CS_MYCUSTOMER_ITEM_CUSTEOMERNAME];
        pd.customerMobile = [params objectForKey:XN_CS_MYCUSTOMER_ITEM_CUSTEOMERMOBILE];
        pd.registerTime = [params objectForKey:XN_CS_MYCUSTOMER_ITEM_REGISTERTIME];
        pd.nearInvestAmount = [params objectForKey:XN_CS_MYCUSTOMER_ITEM_NEARINVESTAMT];
        pd.nearInvestDate = [params objectForKey:XN_CS_MYCUSTOMER_ITEM_NEARINVESTDATE];
        pd.nearEndDate = [params objectForKey:XN_CS_MYCUSTOMER_ITEM_NEWAENDDATE];
        pd.totalInvestAmount = [params objectForKey:XN_CS_MYCUSTOMER_ITEM_TOTALINVESTAMOUNT];
        pd.totalInvestCount = [params objectForKey:XN_CS_MYCUSTOMER_ITEM_TOTALINVESTCOUNT];
        pd.importantCustomer = [[params objectForKey:XN_CS_MYCUSTOMER_ITEM_IMPROTANT] boolValue];
        pd.freeCustomer = [params objectForKey:XN_CS_MYCUSTOMER_ITEM_FREECUSTOMER];
        pd.easeMobAccount = [params objectForKey:XN_CS_MYCUSTOMER_ITEM_EASEMOBACCT];
        pd.image = [params objectForKey:XN_CS_MYCUSTOMER_ITEM_IMAGE];
        pd.readFlag = [[params objectForKey:XN_CS_MYCUSTOMER_ITEM_READFLAG] isEqualToString:@"0"]?NO:YES;
        
        return pd;
    }
    return nil;
}

@end
