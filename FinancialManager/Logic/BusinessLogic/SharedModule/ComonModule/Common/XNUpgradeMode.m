//
//  XNUpgradeMode.m
//  FinancialManager
//
//  Created by xnkj on 15/10/30.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import "XNUpgradeMode.h"

@implementation XNUpgradeMode

+ (instancetype )initUpgradeWithObject:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNUpgradeMode * pd = [[XNUpgradeMode alloc]init];
        
        pd.downloadUrl = [params objectForKey:XN_COMMON_UPGRADE_DOWNLOADURL];
        pd.issueTime = [params objectForKey:XN_COMMON_UPGRADE_ISSUETIME];
        pd.minVersion = [params objectForKey:XN_COMMON_UPGRADE_MINVERSION];
        pd.name = [params objectForKey:XN_COMMON_UPGRADE_NAME];
        pd.openReg = [params objectForKey:XN_COMMON_UPGRADE_OPENREG];
        pd.regHints = [params objectForKey:XN_COMMON_UPGRADE_REGHINTS];
        pd.updateHints = [params objectForKey:XN_COMMON_UPGRADE_UPDATEHINTS];
        
        NSString * composeStr = @"";
        if ([NSObject isValidateInitString:[params objectForKey:XN_COMMON_UPGRADE_UPDATEHINTS]]) {
            
            pd.updateTitle = [[[params objectForKey:XN_COMMON_UPGRADE_UPDATEHINTS] componentsSeparatedByString:@"&"] firstObject];
            
            NSString * updateContent = [[[[[params objectForKey:XN_COMMON_UPGRADE_UPDATEHINTS] componentsSeparatedByString:@"&"] lastObject] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"；" withString:@";"];
            
            NSArray * content = [updateContent componentsSeparatedByString:@";"];
            
            composeStr = content.count>0?content[0]:@"";
            for(NSInteger index = 1; index < content.count ; index ++)
            {
                composeStr = [[composeStr stringByAppendingFormat:@"\n%@",content[index]] stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
        }
        pd.updateContent = composeStr;
        
        
        pd.upgradeType = [params objectForKey:XN_COMMON_UPGRADE_UPGRADE];
        pd.version = [params objectForKey:XN_COMMON_UPGRADE_VERSION];
        
        return pd;
    }
    return nil;
}
@end
