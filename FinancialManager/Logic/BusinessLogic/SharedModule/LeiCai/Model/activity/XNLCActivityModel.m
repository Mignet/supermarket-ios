//
//  XNLCActivityModel.m
//  FinancialManager
//
//  Created by xnkj on 04/11/2016.
//  Copyright © 2016 xiaoniu. All rights reserved.
//

#import "XNLCActivityModel.h"

@implementation XNLCActivityModel

+ (instancetype)initLCActivityModeWithParams:(NSDictionary *)params
{
    if([NSObject isValidateObj:params])
    {
        XNLCActivityModel * pd = [[XNLCActivityModel alloc]init];
        
        pd.activityCode = [params objectForKey:@"activityCode"];
        pd.activityName = [params objectForKey:@"activityName"];
        pd.activityDesc = [params objectForKey:@"activityDesc"];
        pd.activityImg = [params objectForKey:@"activityImg"];
        pd.activityPlatform = [params objectForKey:@"activityPlatform"];
        pd.startDate = [params objectForKey:@"startDate"];
        pd.endDate = [params objectForKey:@"endDate"];
        pd.title = [params objectForKey:@"activityPlatform"];
        pd.subTitle = [params objectForKey:@"activityName"];
        pd.activityStatus = [params objectForKey:@"activityStatus"];
        
        return pd;
    }
    
    return nil;
}
@end
