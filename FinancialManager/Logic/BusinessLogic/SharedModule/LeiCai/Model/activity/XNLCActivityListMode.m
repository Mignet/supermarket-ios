//
//  XNLCActivityListMode.m
//  FinancialManager
//
//  Created by xnkj on 04/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNLCActivityListMode.h"
#import "XNLCActivityModel.h"

@implementation XNLCActivityListMode

+ (instancetype)initLCActivityListWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNLCActivityListMode * pd = [[XNLCActivityListMode alloc]init];
        
        pd.pageIndex = [NSString stringWithFormat:@"%@",[params objectForKey:@"pageIndex"]];
        pd.pageSize = [NSString stringWithFormat:@"%@",[params objectForKey:@"pageSize"]];
        pd.totalCount = [NSString stringWithFormat:@"%@",[params objectForKey:@"totalCount"]];
        pd.pageCount = [NSString stringWithFormat:@"%@",[params objectForKey:@"pageCount"]];
        pd.activityArray = [NSMutableArray array];
        
        XNLCActivityModel * mode = nil;
        for (NSDictionary * param in [params objectForKey:@"datas"]) {
            
            mode = [XNLCActivityModel initLCActivityModeWithParams:param];
            [pd.activityArray addObject:mode];
        }
        
        return pd;
    }
    return nil;
}

@end
