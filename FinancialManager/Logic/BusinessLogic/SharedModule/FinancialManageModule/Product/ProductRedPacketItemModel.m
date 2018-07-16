//
//  ProductRedPacketItemModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/25.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import "ProductRedPacketItemModel.h"

@implementation ProductRedPacketItemModel

+ (instancetype)initWithProductRedPacketItemModelParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        ProductRedPacketItemModel *pd = [[ProductRedPacketItemModel alloc] init];
        
        pd.amount = [params objectForKey:@"amount"];
        pd.amountLimit = [params objectForKey:@"amountLimit"];
        pd.cfplannerId = [params objectForKey:@"cfplannerId"];
        pd.cfplannerMobile = [params objectForKey:@"cfplannerMobile"];
        pd.cfplannerName = [params objectForKey:@"cfplannerName"];
        
        
        pd.createTime = [params objectForKey:@"createTime"];
        pd.expiresDate = [params objectForKey:@"expiresDate"];
        pd.id = [params objectForKey:@"id"];
        pd.investLlimit = [params objectForKey:@"investLlimit"];
        pd.money = [params objectForKey:@"money"];
        
        
        pd.name = [params objectForKey:@"name"];
        pd.platformId = [params objectForKey:@"platformId"];
        pd.platformLimit = [params objectForKey:@"platformLimit"];
        pd.platformName = [params objectForKey:@"platformName"];
        pd.productDeadline = [params objectForKey:@"productDeadline"];
        
        
        pd.productId = [params objectForKey:@"productId"];
        pd.productLimit = [params objectForKey:@"productLimit"];
        pd.productType = [params objectForKey:@"productType"];
        pd.redpacketDetailId = [params objectForKey:@"redpacketDetailId"];
        pd.redpacketId = [params objectForKey:@"redpacketId"];
        
        pd.remark = [params objectForKey:@"remark"];
        pd.ruleId = [params objectForKey:@"ruleId"];
        pd.sendId = [params objectForKey:@"sendId"];
        pd.senderUserId = [params objectForKey:@"senderUserId"];
        pd.status = [params objectForKey:@"status"];
        
        
        pd.type = [params objectForKey:@"type"];
        pd.updateTime = [params objectForKey:@"updateTime"];
        pd.userId = [params objectForKey:@"userId"];
        pd.userMobile = [params objectForKey:@"userMobile"];
        pd.userName = [params objectForKey:@"userName"];
        
        return pd;
    }
    
    return nil;
}

@end
