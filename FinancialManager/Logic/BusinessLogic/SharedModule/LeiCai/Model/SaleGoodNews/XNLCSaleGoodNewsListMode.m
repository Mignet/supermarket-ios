//
//  XNLCSaleGoodNewsListMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 7/26/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNLCSaleGoodNewsListMode.h"
#import "XNLCSaleGoodNewsItemMode.h"

@implementation XNLCSaleGoodNewsListMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNLCSaleGoodNewsListMode *mode = [[XNLCSaleGoodNewsListMode alloc] init];
        mode.pageIndex = [params objectForKey:XNLC_SALE_GOOD_NEWS_LIST_MODE_PAGEINDEX];
        mode.pageSize = [params objectForKey:XNLC_SALE_GOOD_NEWS_LIST_MODE_PAGESIZE];
        mode.pageCount = [params objectForKey:XNLC_SALE_GOOD_NEWS_LIST_MODE_PAGECOUNT];
        mode.totalCount = [params objectForKey:XNLC_SALE_GOOD_NEWS_LIST_MODE_TOTALCOUNT];
        
        XNLCSaleGoodNewsItemMode *itemMode = nil;
        mode.datas = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in [params objectForKey:XNLC_SALE_GOOD_NEWS_LIST_MODE_GOODTRANSLIST])
        {
            itemMode = [XNLCSaleGoodNewsItemMode initWithObject:dic];
            [mode.datas addObject:itemMode];
        }
        return mode;
    }
    return nil;
}

@end
