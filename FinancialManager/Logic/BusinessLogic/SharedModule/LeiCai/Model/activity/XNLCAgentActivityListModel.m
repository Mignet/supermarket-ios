//
//  XNLCAgentActivityListModel.m
//  FinancialManager
//
//  Created by xnkj on 07/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNLCAgentActivityListModel.h"
#import "XNLCAgentActivityModel.h"

@implementation XNLCAgentActivityListModel

+ (instancetype)initLCAgentActivityListWithParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNLCAgentActivityListModel * pd = [[XNLCAgentActivityListModel alloc]init];
        
        pd.pageIndex = [NSString stringWithFormat:@"%@",[params objectForKey:@"pageIndex"]];
        pd.pageSize = [NSString stringWithFormat:@"%@",[params objectForKey:@"pageSize"]];
        pd.totalCount = [NSString stringWithFormat:@"%@",[params objectForKey:@"totalCount"]];
        pd.pageCount = [NSString stringWithFormat:@"%@",[params objectForKey:@"pageCount"]];
        
        pd.agentActivityArray = [[NSMutableArray alloc]init];
        XNLCAgentActivityModel * mode = nil;
        for (NSDictionary * param in [params objectForKey:@"datas"]) {
            
            mode = [XNLCAgentActivityModel initLCAgentActivityModeWithParams:param];
            [pd.agentActivityArray addObject:mode];
        }
        
        return pd;
    }
    return nil;
}

@end
