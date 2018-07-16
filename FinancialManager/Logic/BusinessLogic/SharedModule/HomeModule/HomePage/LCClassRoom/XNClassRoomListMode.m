//
//  XNClassRoomListMode.m
//  FinancialManager
//
//  Created by xnkj on 13/09/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import "XNClassRoomListMode.h"
#import "XNGrowthManualCategoryItemMode.h"

@implementation XNClassRoomListMode

+ (instancetype)initClassRoomListWithParams:(NSDictionary *)params
{
    if (params) {
        
        NSArray * paramList = [params objectForKey:XN_HOME_CLASSROOM_DATAS];
        if (paramList) {
        
            XNClassRoomListMode * pd = [[XNClassRoomListMode alloc]init];
            
            NSMutableArray * nameArray = [NSMutableArray array];
            NSMutableArray * linkArray = [NSMutableArray array];
            NSMutableArray * modeArray = [NSMutableArray array];
            
            NSString * name = @"";
            NSString * link = @"";
            XNGrowthManualCategoryItemMode * mode = nil;
            for (NSDictionary * param in paramList) {
                
                name = [param objectForKey:XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_TITLE];
                link = [_LOGIC getWebUrlWithBaseUrl:[NSString stringWithFormat:@"%@%@",@"/pages/guide/handbook.html?id=",[param objectForKey:XN_GROWTH_MANUAL_CATEGORY_ITEM_MODE_ID]]];
                mode = [XNGrowthManualCategoryItemMode initWithObject:param];
                
                [nameArray addObject:name];
                [linkArray addObject:link];
                [modeArray addObject:mode];
            }
            pd.classRoomItemNameList = nameArray;
            pd.classRoomUrlItemList = linkArray;
            pd.classRoomItemModeList = modeArray;
            
            return pd;
        }
    }
    return nil;
}

@end
