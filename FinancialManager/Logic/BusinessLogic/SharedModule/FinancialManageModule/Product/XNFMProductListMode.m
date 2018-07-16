//
//  XNFMProductListMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNFMProductListMode.h"

#import "XNFMProductListItemMode.h"

@implementation XNFMProductListMode
+ (instancetype )initProductListWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNFMProductListMode * pd = [[XNFMProductListMode alloc]init];
        
        pd.cateId = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_CATE_ID];
        pd.cateName = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_CATE_NAME];
        pd.identifier = [params objectForKey:XN_FM_PRODUCTLIST_ITEM_CATE_TYEP];
        
        //计算数组
        XNFMProductListItemMode * item = nil;
        NSMutableArray * array = [NSMutableArray array];
        for (NSDictionary * obj in [params objectForKey:XN_FM_PRODUCTLIST_ITEM_DATAS]) {
            
            item = [XNFMProductListItemMode initProductListItemWithObject:obj];
            
            [array addObject:item];
        }
        pd.productItemArray = array;
        
        return pd;
    }
    return nil;
}
@end
