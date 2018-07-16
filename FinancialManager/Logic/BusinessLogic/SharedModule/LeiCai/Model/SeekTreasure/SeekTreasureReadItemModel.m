//
//  SeekTreasureReadItemModel.m
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import "SeekTreasureReadItemModel.h"

@implementation SeekTreasureReadItemModel

/****
 #define Seek_Treasure_Read_appType @"appType"
 #define Seek_Treasure_Read_content @"content"
 #define Seek_Treasure_Read_creator @"creator"
 #define Seek_Treasure_Read_crtTime @"crtTime"
 #define Seek_Treasure_Read_extends1 @"extends1"
 #define Seek_Treasure_Read_extends2 @"extends2"
 #define Seek_Treasure_Read_extends3 @"extends3"
 #define Seek_Treasure_Read_id @"id"
 #define Seek_Treasure_Read_img @"img"
 #define Seek_Treasure_Read_isStick @"isStick"
 #define Seek_Treasure_Read_linkUrl @"linkUrl"
 #define Seek_Treasure_Read_modifiyTime @"modifiyTime"
 #define Seek_Treasure_Read_readingAmount @"readingAmount"
 #define Seek_Treasure_Read_shareIcon @"shareIcon"
 #define Seek_Treasure_Read_showInx @"showInx"
 #define Seek_Treasure_Read_source @"source"
 #define Seek_Treasure_Read_status @"status"
 #define Seek_Treasure_Read_summary @"summary"
 #define Seek_Treasure_Read_title @"title"
 #define Seek_Treasure_Read_typeCode @"typeCode"
 #define Seek_Treasure_Read_typeName @"typeName"
 #define Seek_Treasure_Read_validBegin @"validBegin"
 #define Seek_Treasure_Read_validEnd @"validEnd"

 ***/

+ (instancetype)initSeekTreasureReadItemModelParams:(NSDictionary *)params
{
    if ([NSObject isValidateObj:params]) {
        
        SeekTreasureReadItemModel * pd = [[SeekTreasureReadItemModel alloc]init];
        
        pd.appType = [params objectForKey:Seek_Treasure_Read_appType];
        
        pd.content = [params objectForKey:Seek_Treasure_Read_content];
        pd.creator = [params objectForKey:Seek_Treasure_Read_creator];
        pd.crtTime = [params objectForKey:Seek_Treasure_Read_crtTime];
        pd.extends1 = [params objectForKey:Seek_Treasure_Read_extends1];
        pd.extends2 = [params objectForKey:Seek_Treasure_Read_extends2];
        pd.extends3 = [params objectForKey:Seek_Treasure_Read_extends3];
        
        pd.itemId = [params objectForKey:Seek_Treasure_Read_id];
        pd.img = [params objectForKey:Seek_Treasure_Read_img];
        pd.isStick = [params objectForKey:Seek_Treasure_Read_isStick];
        pd.linkUrl = [params objectForKey:Seek_Treasure_Read_linkUrl];
        pd.shareIcon = [params objectForKey:Seek_Treasure_Read_shareIcon];
        pd.modifiyTime = [params objectForKey:Seek_Treasure_Read_modifiyTime];
        pd.readingAmount = [params objectForKey:Seek_Treasure_Read_readingAmount];
        pd.shareIcon = [params objectForKey:Seek_Treasure_Read_shareIcon];
        
        pd.isStick = [NSString stringWithFormat:Seek_Treasure_Read_isStick];
        pd.linkUrl = [params objectForKey:Seek_Treasure_Read_linkUrl];
        pd.shareIcon = [params objectForKey:Seek_Treasure_Read_shareIcon];
        pd.modifiyTime = [params objectForKey:Seek_Treasure_Read_modifiyTime];
        pd.readingAmount = [params objectForKey:Seek_Treasure_Read_readingAmount];
        pd.shareIcon = [params objectForKey:Seek_Treasure_Read_shareIcon];

        
        pd.showInx = [params objectForKey:Seek_Treasure_Read_showInx];
        pd.source = [params objectForKey:Seek_Treasure_Read_source];
        pd.status = [params objectForKey:Seek_Treasure_Read_status];
        pd.summary = [params objectForKey:Seek_Treasure_Read_summary];
        pd.title = [params objectForKey:Seek_Treasure_Read_title];
        pd.typeCode = [params objectForKey:Seek_Treasure_Read_typeCode];

        pd.typeName = [params objectForKey:Seek_Treasure_Read_typeName];
        pd.validBegin = [params objectForKey:Seek_Treasure_Read_validBegin];
        pd.validEnd = [params objectForKey:Seek_Treasure_Read_validEnd];
        pd.msgType = [params objectForKey:Seek_Treasure_Read_LABEL];
        
        return pd;
    }
    
    return nil;
}

@end
