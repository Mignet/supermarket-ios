//
//  SeekTreasureReadItemModel.h
//  FinancialManager
//
//  Created by 张吉晴 on 2017/10/23.
//  Copyright © 2017年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

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
#define Seek_Treasure_Read_LABEL @"label"

@interface SeekTreasureReadItemModel : NSObject

//appType = 1;
@property (nonatomic, copy) NSString *appType;

//content = "";
@property (nonatomic, copy) NSString *content;

//creator = "\"herongdou\"";
@property (nonatomic, copy) NSString *creator;

//crtTime = "2017-08-09 18:01:38";
@property (nonatomic, copy) NSString *crtTime;

//extends1 = "";
@property (nonatomic, copy) NSString *extends1;

//extends2 = "";
@property (nonatomic, copy) NSString *extends2;

//extends3 = "";
@property (nonatomic, copy) NSString *extends3;

//id = 7;
@property (nonatomic, copy) NSString *itemId;

//img = d2db159d3ccb3a538b3cb71c8b279650;
@property (nonatomic, copy) NSString *img;

///isStick = "";
@property (nonatomic, copy) NSString *isStick;

//linkUrl = "";
@property (nonatomic, copy) NSString *linkUrl;

//modifiyTime = "2017-08-09 18:01:38";
@property (nonatomic, copy) NSString *modifiyTime;

//readingAmount = 124;
@property (nonatomic, copy) NSString *readingAmount;

//shareIcon = 2c2c30c5d3d6e128f4dae64179efd586;
@property (nonatomic, copy) NSString *shareIcon;

//showInx = "";
@property (nonatomic, copy) NSString *showInx;

//source = "\U730e\U8d22\U5927\U5e08";
@property (nonatomic, copy) NSString *source;

//status = 1;
@property (nonatomic, copy) NSString *status;

//summary = "\U730e\U8d22\U5927\U5e08\U65b0\U624b\U64cd\U4f5c\U6d41\U7a0b";
@property (nonatomic, copy) NSString *summary;

//title = "\U730e\U8d22\U5927\U5e08\U65b0\U624b\U64cd\U4f5c\U6d41\U7a0b";
@property (nonatomic, copy) NSString *title;

//typeCode = 1;
@property (nonatomic, copy) NSString *typeCode;

//typeName = "\U65b0\U624b\U8bfe\U5802";
@property (nonatomic, copy) NSString *typeName;

//validBegin = "";
@property (nonatomic, copy) NSString *validBegin;

//validEnd = "";
@property (nonatomic, copy) NSString *validEnd;

@property (nonatomic, copy) NSString * msgType;//今日财经早知道,新版猎财攻略



+ (instancetype)initSeekTreasureReadItemModelParams:(NSDictionary *)params;

@end
