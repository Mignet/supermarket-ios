//
//  XNFMProductListMode.h
//  FinancialManager
//
//  Created by xnkj on 15/10/14.
//  Copyright © 2015年 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*cateId = 1000;
 cateName = "\U70ed\U95e8\U4ea7\U54c1";*/

#define XN_FM_PRODUCTLIST_ITEM_CATE_ID @"cateId"
#define XN_FM_PRODUCTLIST_ITEM_CATE_NAME @"cateName"
#define XN_FM_PRODUCTLIST_ITEM_CATE_TYEP @"identifier" //hot 热门，fund 基金
#define XN_FM_PRODUCTLIST_ITEM_DATAS @"datas"

@interface XNFMProductListMode : NSObject

@property (nonatomic, strong) NSString * cateId;
@property (nonatomic, strong) NSString * cateName;
@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSArray  * productItemArray;

+ (instancetype )initProductListWithObject:(NSDictionary *)params;

@end
