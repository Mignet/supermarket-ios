//
//  XNFMProductCategoryListMode.m
//  FinancialManager
//
//  Created by xnkj on 5/24/16.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNFMProductCategoryListMode.h"

#import "XNFMProductListItemMode.h"

@implementation XNFMProductCategoryListMode

+ (instancetype)initProductCategoryListWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNFMProductCategoryListMode * pd = [[XNFMProductCategoryListMode alloc]init];
        
        pd.pageIndex  = [params objectForKey: XN_CS_MYCUSTOMERLIST_PAGEINDEX];
        pd.pageSize   = [params objectForKey: XN_CS_MYCUSTOMERLIST_PAGESIZE];
        pd.pageCount  = [params objectForKey: XN_CS_MYCUSTOMERLIST_PAGECOUNT];
        pd.totalCount = [params objectForKey: XN_CS_MYCUSTOMERLIST_TOTALCOUNT];
        
        //计算数组
        XNFMProductListItemMode * item = nil;
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * obj in [params objectForKey:XN_CS_MYCUSTOMERLIST_DATA]) {
            
            item = [XNFMProductListItemMode initProductListItemWithObject:obj];
            
            [array addObject:item];
        }
        pd.dataArray = [NSArray arrayWithArray:array];

        
        return pd;
    }
    return nil;
}

@end
