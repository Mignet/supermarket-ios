//
//  XNInsuranceItem.h
//  FinancialManager
//
//  Created by xnkj on 13/09/2017.
//  Copyright © 2017 xiaoniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XN_INSURANCE_ITEM_CASECODE @"caseCode"
#define XN_INSURANCE_ITEM_FIRSTCATEGORY @"fristCategory"
#define XN_INSURACEN_ITEM_PRODUCTNAME @"productName"
#define XN_INSURANCE_ITEM_PRODUCTDESC @"fullDescription"
#define XN_INSURANCE_ITEM_PRODUCTPRICE @"price"
#define XN_INSURANCE_ITEM_PRODUCTPRICESTRING @"priceString"
#define XN_INSURANCE_ITEM_PRODUCTBAKIMG @"productBakimg"
#define XN_INSURANCE_ITEM_FEERATIO @"feeRatio"

@interface XNInsuranceItem : NSObject

@property (nonatomic, strong) NSString * caseCode;
@property (nonatomic, strong) NSString * fristCategory; //保险分类（1-意外险 2-旅游险 3-家财险 4-医疗险 5-重疾险 6-年金险）
@property (nonatomic, strong) NSString * productName;//产品名称
@property (nonatomic, strong) NSString * fullDescription;//产品描述
@property (nonatomic, strong) NSString * price; //起投金额
@property (nonatomic, strong) NSString * priceString;
@property (nonatomic, strong) NSString * productBakimg; //保险背景图片
@property (nonatomic, strong) NSString * feeRatio;

+ (instancetype)initInsuranceWithParams:(NSDictionary *)params;
@end
