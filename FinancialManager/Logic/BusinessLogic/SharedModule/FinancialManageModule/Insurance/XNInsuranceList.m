//
//  XNInsuranceList.m
//  FinancialManager
//
//  Created by xnkj on 13/09/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNInsuranceList.h"
#import "XNInsuranceItem.h"

@implementation XNInsuranceList

+ (instancetype)initInsuranceListWithParams:(NSDictionary *)params
{
    if (params) {
        
        XNInsuranceList * pd = [[XNInsuranceList alloc]init];
        
        pd.pageIndex = [NSString stringWithFormat:@"%@",[params objectForKey:XN_BUND_LIST_MODE_PAGEINDEX]];
        pd.pageCount = [NSString stringWithFormat:@"%@",[params objectForKey:XN_BUND_LIST_MODE_PAGECOUNT]];
        
        XNInsuranceItem * item = nil;
        NSMutableArray * arr = [NSMutableArray array];
        for (NSDictionary * param in [params objectForKey:XN_BUND_LIST_MODE_DATAS]) {
            
            item = [XNInsuranceItem initInsuranceWithParams:param];
            [arr addObject:item];
        }
        pd.insuranceList = arr;
        
        return pd;
    }
    return nil;
}
@end
