//
//  XNLCSchoolListMode.m
//  FinancialManager
//
//  Created by xnkj on 07/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNLCSchoolListMode.h"

#import "XNLCSchoolItemMode.h"

@implementation XNLCSchoolListMode

+ (instancetype)initLCSchoolListWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNLCSchoolListMode * pd = [[XNLCSchoolListMode alloc]init];
        
        pd.pageIndex = [NSString stringWithFormat:@"%@",[params objectForKey:@"pageIndex"]];
        pd.pageSize = [NSString stringWithFormat:@"%@",[params objectForKey:@"pageSize"]];
        pd.totalCount = [NSString stringWithFormat:@"%@",[params objectForKey:@"totalCount"]];
        pd.pageCount = [NSString stringWithFormat:@"%@",[params objectForKey:@"pageCount"]];
        pd.schoolArray = [NSMutableArray array];
        
        XNLCSchoolItemMode * mode = nil;
        for (NSDictionary * param in [params objectForKey:@"datas"]) {
            
            mode = [XNLCSchoolItemMode initLCSchoolItemWithParams:param];
            [pd.schoolArray addObject:mode];
        }
        
        return pd;
    }
    
    return nil;
}
@end
