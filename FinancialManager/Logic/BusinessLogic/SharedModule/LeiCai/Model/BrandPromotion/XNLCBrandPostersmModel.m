//
//  XNLCBrandPostersmModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2018/1/6.
//  Copyright © 2018年 xiaoniu. All rights reserved.
//

#import "XNLCBrandPostersmModel.h"
#import "XNLCBrandListItem.h"

@implementation XNLCBrandPostersmModel

+ (instancetype)createBrandPostersmModel:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        XNLCBrandPostersmModel *pd = [[XNLCBrandPostersmModel alloc] init];
        pd.posterList = [NSMutableArray arrayWithCapacity:0];
        
        NSArray *typeListArr = [params objectForKey:@"posterList"];
        
        for (NSDictionary *mParams in typeListArr) {
            XNLCBrandListItem *item = [XNLCBrandListItem createBrandListItem:mParams];
            [pd.posterList addObject:item];
        }
        
        pd.qrcode = [params objectForKey:@"qrcode"];
        return pd;
    }
    return nil;
}

@end
