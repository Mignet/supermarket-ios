//
//  XNLCLevelPrivilegeMode.m
//  FinancialManager
//
//  Created by ancye.Xie on 6/29/17.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNLCLevelPrivilegeMode.h"

@implementation XNLCLevelPrivilegeMode

+ (instancetype)initWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params])
    {
        XNLCLevelPrivilegeMode *pd = [[XNLCLevelPrivilegeMode alloc] init];
        
        pd.cfpLevelTitleNew = [params objectForKey:XNLC_MODE_CFP_LEVEL_TITLE_NEW];
      
        pd.lowerLevelCfpActualNew = [params objectForKey:XNLC_MODE_LOWER_LEVEL_CFP_ACTUAL_NEW];
        pd.lowerLevelCfpMaxNew = [params objectForKey:XNLC_MODE_LOWER_LEVEL_CFP_MAX_NEW];
        pd.lowerLevelCfp = [params objectForKey:XNLC_MODE_LOWER_LEVEL_CFP];
      
        pd.yearpurAmountActualNew = [params objectForKey:XNLC_MODE_YEARPUR_AMOUNT_ACTUAL_NEW];
        pd.yearpurAmountMaxNew = [params objectForKey:XNLC_MODE_YEARPUR_AMOUNT_MAX_NEW];
       
        pd.cfpLevelContent = [params objectForKey:XNLC_MODE_CFP_LEVEL_CONTENT];
        pd.cfpLevelDetail = [params objectForKey:XNLC_MODE_CFP_LEVEL_DETAIL];
        pd.jobGrade = [params objectForKey:XNLC_MODE_JOB_GRADE];
        pd.jobGradeDesc = [params objectForKey:XNLC_MODE_JOB_GRADE_DESC];
        return pd;
    }
    return nil;
    
}

@end
