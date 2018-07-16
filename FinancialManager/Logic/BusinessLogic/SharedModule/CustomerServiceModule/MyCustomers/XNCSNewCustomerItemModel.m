//
//  XNCSNewCustomerItemModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/17.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "XNCSNewCustomerItemModel.h"

@implementation XNCSNewCustomerItemModel

+ (instancetype )initMyNewCustomerWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNCSNewCustomerItemModel *model = [[XNCSNewCustomerItemModel alloc] init];
        
        model.userId = [params objectForKey:XN_CS_MYCUSTOMER_USERID];
        model.mobile = [params objectForKey:XN_CS_MYCUSTOMER_MOBILE];
        model.grade = [params objectForKey:XN_CS_MYCUSTOMER_ITEM_GRADE];
        model.headImage = [params objectForKey:XN_CS_MYCUSTOMER_HEADIMAGE];
        model.recentTranDate = [params objectForKey:XN_CS_MYCUSTOMER_RECENTTRANDATE];
        model.userName = [params objectForKey:XN_CS_MYCUSTOMER_USERNAME];
        model.registerTime = [params objectForKey:XN_CS_REGISTER_TIME];
         
        return model;
    }
    
    return nil;
}

@end
